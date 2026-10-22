/////////////////////////////////////////////////////
// Envelopes in SuperCollider
/////////////////////////////////////////////////////
// Luis Sanz | Aug 2025 | www.luissanz.ch
/////////////////////////////////////////////////////


////////// 1. The Problem: Hard Stops

// If we just play noise and stop it manually:
x = { PinkNoise.ar * 0.5 }.play;
x.free;

// ❌ This stops IMMEDIATELY → causes clicks
// ✅ Solution: use envelopes for smooth fades and automatic cleanup


////////// 2. What is an Envelope?

/*
Envelope = a shape that changes a parameter over time.

Most common use = amplitude shaping (volume control),
but envelopes can also control:
- frequency
- filter cutoff
- playback speed

Think of envelopes as automation curves that live INSIDE the Synth.
*/


////////// 3. The Simplest Envelope: Line

// Line.kr(start, end, duration, mul, add, doneAction)
// Creates a straight line from start → end in "duration" seconds

// Example: fade-out in 1 second
(
{
    var env = Line.kr(1, 0, 1, doneAction:2); // fade from 1 → 0 in 1 sec
    Pulse.ar(ExpRand(50,300)) * env;          // multiply sound by env
}.play;
)

// doneAction:2 = free the Synth when envelope finishes
// Without it, Synth keeps running silently = wasted CPU


////////// 4. Done Actions

/*
doneAction controls what happens when UGen ends:

0 → do nothing (Synth stays alive)
2 → free Synth automatically ✅ (common for one-shot sounds)

Good practice:
- Use 0 for retriggerable envelopes
- Use 2 for percussive/one-shot sounds
*/


////////// 5. Exponential Line: XLine

// Like Line, but exponential shape
// Our ears hear pitch & loudness exponentially, so this often sounds more natural

// Example: exponential fade-out
(
{
    var env = XLine.kr(1, 0.01, 1, doneAction:2); // exponential fade
    Pulse.ar(ExpRand(50,300)) * env;
}.play;
)


////////// 6. More Flexible Envelopes: Env + EnvGen

// Env = blueprint (envelope shape)
// EnvGen = plays the Env on the server

// Default triangle envelope:
Env.new.plot;   // visualize [0,1,0] over [1,1]

// Custom Env example:
(
{
    var env = EnvGen.kr(
        Env.new(          // Env.new(levels, times, curves)
            [0, 1, 0.1, 0],   // levels
            [0.5, 1, 2],      // durations
            [3, -3, 0]        // curves (shape of each segment)
        ),
        doneAction:2
    );
    Pulse.ar(ExpRand(50,300)) * env;
}.play;
)


////////// 7. Gate and Retriggering

// Unlike Line, EnvGen can be gated (start/stop)
// gate = starts/stops the envelope

(
x = {
    arg gate=0;
    var env = EnvGen.kr(Env.perc, gate); // Env.perc = simple attack/decay
    PinkNoise.ar * env;
}.play;
)

// Trigger the envelope manually:
x.set(\gate, 1); // note on (triggers env)
// (use t_gate for retrigger pulses)


////////// 8. ADSR Envelopes

// Env.adsr(attack, decay, sustain, release)
// ADSR = the "classic" synth envelope
// Sustain stage lasts as long as gate = 1

(
x = {
    arg gate=0;
    var env = EnvGen.kr(Env.adsr, gate, doneAction:2);
    VarSaw.ar(220) * env;
}.play;
)

// Simulate a note press/release:
x.set(\gate, 1); // note on
x.set(\gate, 0); // note off


////////// 9. Good Practices

/*
- Use doneAction:2 for one-shot/percussive sounds
- Use doneAction:0 for retriggerable or sustain-based envelopes
- Always match envelope durations musically
- Visualize envelopes with .plot to understand their shape
*/


////////// 10. Exploring Env.new Shapes

// An Env is a sequence of LEVELS with DURATIONS between them
// Syntax: Env.new(levels, times, curves)

// A simple triangle: start at 0, up to 1, back to 0
e = Env.new([0, 1, 0], [2, 4], 'lin');
e.plot; // y axis = level (0–1), x axis = time (seconds)

// A longer custom shape
e = Env.new([0, 1, 0.5, 0.5, 1, 0.1 ,1, 0], [1, 0.5, 1, 2, 0.4, 3, 1], 'lin');
e.plot;

// Changing the curve
Env.new([0, 1, 0], [2, 4], [0, 0]).plot;   // linear
Env.new([0, 1, 0], [2, 4], [4, 4]).plot;   // exponential curves

// Multi-segment example
Env.new([0, 1, 0.5, 0.2, 0.5, 0], [0.75, 0.1, 3.0, 0.1, 4], 'lin').plot;


////////// 11. Using EnvGen with Env

// As amplitude envelope
(
{
    var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
    SinOsc.ar(470) * EnvGen.kr(env, doneAction: Done.freeSelf);
}.play;
)

// As amplitude + modulation envelope
(
{
    var env = Env([0, 1, 0.5, 0.8, 0, 1.2, 0], [0.01, 0.5, 0.02, 0.5, 0.2, 0.5]);
    var gate = Impulse.kr(MouseX.kr(0.2, 3)); // retrigger with mouse-controlled rate
    var gen  = EnvGen.kr(env, gate);
    SinOsc.ar(270, SinOsc.ar(gen * 73)) * gen * 0.2;
}.play;
)

// Frequency modulation with EnvGen
EnvGen.ar(
    Env([261, 120, 51], [0.035, 0.08], curve: \exp)
);

// Multichannel expansion: EnvGen can output multiple envelopes at once
(
{
    SinOsc.ar(
        EnvGen.kr(
            Env.circle(
                [0, 1, 0, (2..4), 0, LFNoise1.kr(0.1 ! 5) * 10, 0],
                [0.01, 0.6]
            )
        ) * 240 + 300
    ).sum * 0.2
}.play;
)


////////// 12. Summary

/*
- Line / XLine → simple fades, short events
- Env + EnvGen → custom shapes, retriggerable, flexible
- ADSR → classic synth-style (note on/off)
- Env.new.plot → visualize envelope shapes
- doneAction → cleans up resources automatically
*/
