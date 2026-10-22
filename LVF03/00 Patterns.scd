//Patterns

Pbind(\degree, Pseries(0,1,30), \dur, 0.05).play;

//this line is actually fucking annoying; the 0 refers to
// 'scale degree' which apparently means C; 1 would be D, etc
Pbind(\degree, 6).play;
//messing with slightly offset duration
(Pbind(\degree, 0, \dur, 0.75).play;
Pbind(\degree, 1, \dur, 0.74).play;)

//playing around with duration as a sequence
//also, for note, can use \degree, \note, \midinote, and \freq
(
Pbind(
	\freq, Pseq([337, 347, 357], inf),
	\dur, Pseq([0.1,0.25, 0.333, 0.1, 0.05, 0.05, 0.1], inf)
).play;
)

//not the prand()
(
Pbind(
	\freq, Pseq([440, 466.16, 450.16], inf),
	\dur, Prand([0.1,  0.2, 0.3, 0.15, 0.123, 0.667], inf),
	\amp, Pseq([0.1, 0.15, 0.1, 0.13, 0.1, 0.1], inf),
	\legato, Pseq([0.4, 0.4, 0.4, 0.4, 0.4, 0.9], inf),
).play;
)

(
Pbind(
	\freq, Pseq([220, 220, 218, 216, 100, 55], inf),
	\dur, Pseq([0.1,0.25, 0.333, 0.1, 0.05, 0.05, 0.1], inf),
    \amp, Pseq([0.1, 0.3, 0.2, 0.3, 0.8, 0.9], inf),
).play;
)

//use of Pwhite and trace, which prints values to Post
(
Pbind(
	\freq, Pwhite(100,500), //the 500.0 here
	\dur, Prand([0.15, 0.25, 0.3], inf),
	\amp, 0.2,
	\legato, 0.3
).trace.play;
)
//use of Prand and trace, which prints values to Post
(
Pbind(
	\degree, Prand([2,3,4,5,6], inf), //the 500.0 here
	\dur, Prand([0.15, 0.25, 0.3], inf),
	\amp, 0.2,
	\legato, 0.3
).trace.play;
)



// exercise 13.7 d)
// Run the examples below. We use \note instead of \degree in order to play a C minor scale
// (which includes black keys). The list [0, 2, 3, 5, 7, 8, 11, 12] has eight numbers in it,
// corresponding to pitches C, D, E♭, F, G, A♭, B, C, but how many events does each example
// actually play? Why?

//Pseq
(
Pbind(
	\note, Pseq([0,2,3,5,7,8,11,12],4),
	\dur, 0.15;
).play;
)


//Pseq
(
Pbind(
	\note, Prand([0,2,3,5,7,8,11,12],4*8),
	\dur, 0.15;
).play;
)


//Patterns expanded

//Pser
//seems to increment one index of the array n 2nd param times
//wheras for Pseq, 2nd param is count to iterate the whole array
(
Pbind(
	\note, Pser([0,2,3,5,7,8,11,12],11),
	\dur, 0.15;
).trace.play;
)

//Pxrand (compare with Prand to hear the diff
// ecz: I think it excludes the previous note from 'next'
(
Pbind(
	\note, Pxrand([0,2,3,5,7,8,11,12], inf),
	\dur, 0.15;
).trace.play;
)

//Pshuf
(
Pbind(
	\note, Pshuf([0,2,3,5,7,8,22,23],14,3,2),
	\dur, 0.15;
).trace.play;
)


//Pslide
// Takes 4 arguments: list, repeats, length, step
(
Pbind(
	\note, Pslide([0,2,3,5,7,8,11,12], inf, 3, 1),
	\dur, 0.15;
).trace.play;
)

//Pseries
//takes 3 args: start, stop, length
(
Pbind(
	\note, Pseries(0,3,15),
	\dur, 0.1;
).trace.play;
)

