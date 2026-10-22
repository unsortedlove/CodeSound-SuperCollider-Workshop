// SuperCollider Workshop: Pattern Generation
//
// In this workshop, we use one simple sine-wave instrument to explore how
// patterns control pitch, timing, and amplitude. Evaluate each section in order.
// In the SuperCollider IDE, select a block and press Cmd+Enter (macOS) or
// Ctrl+Enter (Windows/Linux) to run it.


// 1. Create the instrument
//
// Evaluate this first. The SynthDef makes a short, clean sine tone for each
// event. Patterns below will provide its frequency, amplitude, and duration.
(
SynthDef(\sine, { |out = 0, freq = 440, amp = 0.15, sustain = 0.2|
	var envelope = EnvGen.kr(
		Env.perc(0.01, sustain),
		doneAction: 2
	);
	var signal = SinOsc.ar(freq) * envelope * amp;

	Out.ar(out, signal ! 2);
}).add;
)


// 2. Play one repeating note
//
// Pbind turns key/value pairs into a stream of events. Here, every event uses
// the sine instrument, plays A4 (440 Hz), and starts half a second later.
// Assigning the player to ~pattern lets you stop it in the next section.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, 440,
	\dur, 0.5,
	\amp, 0.15
).play;
)


// 3. Stop a pattern
//
// Evaluate this whenever you want to stop the currently assigned pattern.
~pattern.stop;


// 4. Make a repeating sequence with Pseq
//
// Pseq plays the list in order. The second argument is how many times to repeat
// the whole list; inf means keep playing until stopped.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pseq([220, 330, 440, 330], inf),
	\dur, 0.4,
	\amp, 0.15
).play;
)


// 5. Give pitch and duration their own sequences
//
// Each key has its own pattern. Both sequences advance once per event, so the
// changes in pitch and rhythm combine into a repeating phrase.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pseq([337, 347, 357, 440], inf),
	\dur, Pseq([0.1, 0.25, 0.33, 0.1, 0.05, 0.05, 0.2], inf),
	\amp, 0.15
).play;
)


// 6. Choose from a list with Prand
//
// Prand chooses a new list item at random for each event. Its second argument
// is the number of choices to make; inf continues indefinitely.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Prand([220, 247, 294, 330, 392, 440], inf),
	\dur, Pseq([0.2, 0.2, 0.4], inf),
	\amp, 0.15
).play;
)


// 7. Vary more than one property
//
// Patterns can control amplitude and legato as well as pitch and duration.
// Legato changes the event's sounding length relative to its duration.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pseq([220, 220, 218, 216, 330, 165], inf),
	\dur, Pseq([0.1, 0.25, 0.33, 0.1, 0.05, 0.05], inf),
	\amp, Pseq([0.1, 0.3, 0.2, 0.3, 0.18, 0.12], inf),
	\legato, Pseq([0.4, 0.4, 0.4, 0.4, 0.4, 0.9], inf)
).play;
)


// 8. Generate values with Pwhite
//
// Pwhite generates random values between its lower and upper bounds. Here it
// chooses a new frequency for every event. trace posts event values to Post.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pwhite(220, 660, inf),
	\dur, Prand([0.15, 0.25, 0.3], inf),
	\amp, 0.15,
	\legato, 0.7
).trace.play;
)


// 9. Compare sequence patterns
//
// Pseq repeats the complete list. With eight values and four repeats, this
// plays 32 events.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pseq([261.63, 293.66, 311.13, 349.23, 392, 415.3, 466.16, 523.25], 4),
	\dur, 0.15,
	\amp, 0.15
).play;
)

// Prand makes the requested number of random choices from the list. This
// example makes 32 choices, and may choose the same frequency consecutively.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Prand([261.63, 293.66, 311.13, 349.23, 392, 415.3, 466.16, 523.25], 32),
	\dur, 0.15,
	\amp, 0.15
).play;
)

// Pser takes the requested number of values from the list in order, then ends.
// This example plays 11 events.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pser([261.63, 293.66, 311.13, 349.23, 392, 415.3, 466.16, 523.25], 11),
	\dur, 0.15,
	\amp, 0.15
).trace.play;
)


// 10. Try other ways to order values

// Pxrand chooses randomly, but avoids choosing the same list item twice in a row.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pxrand([220, 247, 294, 330, 392, 440], inf),
	\dur, 0.2,
	\amp, 0.15
).play;
)

// Pshuf shuffles the list, then plays the shuffled order for each repetition.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pshuf([220, 247, 294, 330, 392, 440], 4),
	\dur, 0.2,
	\amp, 0.15
).play;
)

// Pslide moves through overlapping sections of the list. Its arguments are
// the list, number of repeats, section length, and step size.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pslide([220, 247, 294, 330, 392, 440], inf, 3, 1),
	\dur, 0.2,
	\amp, 0.15
).play;
)

// Pseries generates an arithmetic series: start at 220 Hz, add 30 Hz each
// event, and play 12 events.
(
~pattern = Pbind(
	\instrument, \sine,
	\freq, Pseries(220, 30, 12),
	\dur, 0.15,
	\amp, 0.15
).trace.play;
)


// 11. Workshop exercises
//
// 1. Change one frequency list to create a phrase you like.
// 2. Make a rhythm by changing \dur to a Pseq of short and long values.
// 3. Use Prand or Pxrand for pitch and compare how the results differ.
// 4. Add an \amp pattern with a different number of values than the pitch
//    pattern. Listen for when their cycles line up again.
// 5. Use Pwhite to create a range of pitches, then narrow the range.
//
// Stop the current pattern when you are finished:
~pattern.stop;
