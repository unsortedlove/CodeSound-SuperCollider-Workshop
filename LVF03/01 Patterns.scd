// SuperCollider Workshop: Pattern Generation with Scale Degrees
//
// This lesson builds on 00 Patterns.scd. First evaluate a SynthDef named
// \sine there; this file reuses that instrument and focuses on choosing pitches
// with scale degrees instead of writing frequencies in Hertz.
//
// In the SuperCollider IDE, select a code block and press Cmd+Enter (macOS)
// or Ctrl+Enter (Windows/Linux) to run it.


// 1. Play one scale degree
//
// \degree describes a note by its position in a scale. With C major,
// degree 0 is the root C, degree 1 is the next scale note D, degree 2 is E,
// and so on. Unlike MIDI note numbers, degrees are not semitone steps:
// the scale determines the distance between each degree.
//
// C major degree map:
//
// Degree:              0    1    2    3    4    5    6    7
// Note:                C    D    E    F    G    A    B    C
// Semitones from C:    0    2    4    5    7    9   11   12
//
// Each degree moves to the next note in the scale. The semitone distances
// between degrees are not all equal; degree 7 reaches C in the next octave.
//
// \scale and \root make the pitch mapping explicit. A root of 0 means C;
// changing it transposes the scale. \dur is measured in beats.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 0,
	\degree, 0,
	\dur, 0.5,
	\amp, 0.1
).play;
)


// 2. Play a scale as a repeating sequence
//
// Pseq plays each degree in order. The list [0, 1, 2, 3, 4, 5, 6, 7]
// moves up the scale; degree 7 is the root again, one scale octave higher.
// inf repeats the whole list until the pattern is stopped.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 0,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\dur, 0.3,
	\amp, 0.12
).play;
)


// 3. Make a melody with repeated and descending degrees
//
// Degrees can be used in any order, and can repeat. Negative degrees continue
// below the scale root. Here, the pattern moves up and then back down.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 0,
	\degree, Pseq([0, 2, 4, 2, 1, 3, 5, 3, 0], inf),
	\dur, Pseq([0.2, 0.2, 0.4], inf),
	\amp, 0.12
).play;
)


// 4. Change the scale
//
// The degree list stays the same, but a minor scale gives those degrees
// different intervals and therefore a different sound.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.minor,
	\root, 0,
	\degree, Pseq([0, 2, 4, 2, 1, 3, 5, 3, 0], inf),
	\dur, Pseq([0.2, 0.2, 0.4], inf),
	\amp, 0.12
).play;
)


// 5. Transpose by changing the root
//
// The root is a semitone offset from C: 0 is C, 2 is D, and 7 is G.
// Keep the scale and degrees the same while changing \root to hear the
// whole phrase move to a different starting pitch.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 7,
	\degree, Pseq([0, 2, 4, 2, 1, 3, 5, 3, 0], inf),
	\dur, 0.25,
	\amp, 0.12
).play;
)


// 6. Choose scale degrees at random
//
// Prand chooses a degree from the list for every event. It can repeat the
// same degree on consecutive events.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 0,
	\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\dur, Pseq([0.2, 0.2, 0.4], inf),
	\amp, 0.12
).play;
)


// 7. Avoid consecutive repeats
//
// Pxrand chooses randomly from the degree list, but avoids choosing the same
// list item twice in a row. Compare it with Prand above.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 0,
	\degree, Pxrand([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\dur, 0.25,
	\amp, 0.12
).play;
)


// 8. Slide through overlapping scale fragments
//
// Pslide outputs a section of the degree list, then shifts its starting
// position and outputs another section. Here, each section has three degrees
// and the starting position moves forward by one. The sections overlap:
// [0, 1, 2], then [1, 2, 3], then [2, 3, 4], and so on.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 0,
	\degree, Pslide([0, 1, 2, 3, 4, 5, 6, 7], inf, 3, 0, 1),
	\dur, 0.2,
	\amp, 0.12
).play;
)


// 9. Generate a rising line
//
// Pseries starts at degree 0 and adds one degree for each event. This makes
// an ascending major-scale line. A negative step would make it descend.
(
~pattern = Pbind(
	\instrument, \sine,
	\scale, Scale.major,
	\root, 0,
	\degree, Pseries(0, 1, 16),
	\dur, 0.2,
	\amp, 0.12
).play;
)


// 10. Workshop exercises
//
// 1. Change the degree list to make a melody with a repeated note or a leap.
// 2. Compare Scale.major and Scale.minor using the same degree sequence.
// 3. Change \root while keeping the degree pattern and scale the same.
// 4. Compare Prand and Pxrand. Do they create the same kind of repetition?
// 5. Use negative degrees or degrees above 7 to extend the melody beyond one
//    scale octave.
//
// Stop the current pattern when you are finished:
~pattern.stop;
