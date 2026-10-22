/////////////////////////////////////////////////////
// SuperCollider – Simple Sine Wave SynthDef
/////////////////////////////////////////////////////
// Luis Sanz | Aug 2025 | www.luissanz.ch
/////////////////////////////////////////////////////


////////// 1. Simple Sine Wave SynthDef

(
SynthDef(\sineSimple, {
    arg freq = 440, amp = 0.2, sustain = 1;
    var env, sig;

    // Envelope: percussive, can be controlled with \legato if needed
    env = EnvGen.kr(Env.perc(0.01, sustain, 1, -4), doneAction:2);

    // Sine wave oscillator
    sig = SinOsc.ar(freq) * env * amp;

    // Stereo output
    Out.ar(0, sig ! 2);
}).add;
)

/*
Pbinds below use \degree with \scale to generate pitches
You can use arrays for chords or sequences for arpeggios
*/


// Example 1: Play a Scale

(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf), // scale degrees
    \octave, 5,
    \dur, 0.25
).play;
)


// Example 2: Play Chords

(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([[0,2,4], [1,3,5], [2,4,6]], inf), // chords as arrays
    \dur, 0.25
).play;
)

// 7th chords (minor scale example)
(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.minor,
    \degree, Pseq([[0,2,4,6], [3,5,7,9]], inf),
    \octave, 5,
    \dur, 0.5
).play;
)


// Example 3: Arpeggios

(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([0,2,4,2], inf),
    \octave, 5,
    \dur, 0.25
).play;
)


// Example 4: Chord and Arpeggio Comparison

// Chord (all notes at once)
(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([[0,2,4]], inf),
    \dur, 1
).play;
)

// Arpeggio (notes played sequentially)
(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([0,2,4], inf),
    \dur, 0.25
).play;
)

// Strummed chord
(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([[0,2,4]], inf),
    \dur, 1,
    \strum, 0.08 // delay between chord notes
).play;
)

// Example 5: Legato / Staccato

// Short notes (staccato)
(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([0,2,4,5], inf),
    \dur, 0.5,
    \legato, 0.3 // note length = 30% of duration
).play;
)

// Overlapping notes (smooth legato)
(
Pbind(
    \instrument, \sineSimple,
    \scale, Scale.major,
    \degree, Pseq([0,2,4,5], inf),
    \dur, 0.5,
    \legato, 1.5 // note length = 150% of duration
).play;
)


////////// Tips

/*
- \degree can be a single number or an array (for chords)
- \scale defines the scale context for degree numbers
- \octave shifts all notes
- \root shifts the scale root
- \dur is note duration in beats
- \dur = 1 → 1 beat (1 second at 60 bpm).
- \dur = 0.5 → half a beat (0.5 seconds at 60 bpm, 0.25 seconds at 120 bpm).
- \legato controls overlap between notes
- \strum adds delay between notes in a chord
*/
