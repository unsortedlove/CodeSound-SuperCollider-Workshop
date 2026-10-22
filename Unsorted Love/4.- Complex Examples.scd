/////////////////////////////////////////////////////
// Scales and Degrees in SuperCollider
/////////////////////////////////////////////////////
// Luis Sanz | Aug 2025 | www.luissanz.ch
/////////////////////////////////////////////////////

////////// 1. SynthDef
(
SynthDef(\tremolo, {
	arg freq=500, amp=0.2, atk=1, rel=2, pan=0, trem=2;
	var env, sig;

	// Percussive envelope
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);

	// Feedback oscillator with tremolo
	sig = SinOscFB.ar(freq, 0.9) * SinOsc.ar(trem) * env * amp;

	// Stereo output
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;
)

/*
Arguments explanation:
freq → pitch in Hz
amp → amplitude
atk, rel → envelope attack and release in seconds
pan → stereo position
trem → tremolo frequency
doneAction:2 → free synth when envelope ends
*/


////////// 2. Pattern Example: \unpredictable

// Define a TempoClock

t = TempoClock(120/60); // 120 bpm
t.tempo_(60/60); //  change bpm


// Unpredictable pattern with random melody/chords
(
Pbindef(
	\unpredictable,
	\instrument, \tremolo,
	\scale, Scale.minor,
	\degree, Pxrand([0, 1, 2, 3, 4, 5, 6, [-7, -3, 0, 2, 4, 6], 7], inf),
	\atk, 0.01,
	\rel, Phprand(3.0, 5.0, inf), // use floating-point for smoother releases
	\trem, Pkey(\degree) + Pseq([0.1, 0.2, 0.5, 0.7], inf),
	\amp, Pseq([Pn(0.6, 0.5), 0.06], inf),
	\pan, Pwhite(-0.3, 0.3, inf),
	\dur, Pseq([Pseq([0.1,0.2,0.5,0.7], inf), Pn(0.1, 6), 1.3, 1], inf),
).play(t);
)

Pbindef(\unpredictable).stop;


////////// 3. Pattern Example: \predictable
(
Pbindef(
	\predictable,
	\instrument, \tremolo,
	\scale, Scale.minor,
	\degree, Pxrand([0,1,2,3,4,5,6,[-7,-3,0,2,4,6],7], inf),
	\trem, Pkey(\degree) + Pseq([0.1,0.2,0.5,0.7], inf),
	\atk, Pwhite(0.1, 1.0, inf),  // floating-point attack
	\rel, Pwhite(1.5, 3.0, inf),  // floating-point release
	\amp, Pseq([Pn(0.6, 0.5), 0.06], inf),
	\pan, Pwhite(-0.3, 0.3, inf),
	\dur, 0.2,
).play(t);
)

Pbindef(\predictable).stop;


////////// 4. Other Pattern Examples: \erratic & \shimmering

// Erratic pattern: variable rhythm and pan
(
Pbindef(
	\erratic,
	\instrument, \tremolo,
	\degree, Prand([Phprand(-7, 7, 1), Pxrand([0,1,2,3,4,5,6,[-7,-3,0,2,4,6],7],1)], inf),
	\scale, Scale.minor,
	\trem, Pkey(\degree) + Pseq([0.1,0.2,0.5,0.7], inf),
	\dur, Pseq([Pseries(0.02*15,-0.02,15).clip(0.01,1.5), Pseries(0.01,0.01,15)], inf),
	\amp, 0.05,
	\pan, Prand([Pwhite(-0.8,0.8,1), Pseries(-1,0.08,1).clip(-0.3,0.3)], inf),
).play(t, quant:4);
)

Pbindef(\erratic).stop;

// Shimmering pattern: chords, octaves, tremolo
(
Pbindef(
	\shimmering,
	\instrument, \tremolo,
	\scale, Scale.minor,
	\degree, Pxrand([
		[0,2,4], [0,3,5], [0,2,4,6],
		[-7,-3,0,2], [0,4,7], [2,4,6], [4,6,8]
	], inf),
	\octave, Pseq([3,4,5,4], inf),
	\atk, 0.01,
	\rel, Phprand(3.0,5.0,inf),
	\trem, Pkey(\degree) * Pseq([0.1,0.2,0.5,0.7], inf),
	\amp, Pseq([Pn(0.6,0.5),0.06], inf),
	\pan, Pwhite(-0.3,0.3,inf),
	\dur, Pseq([Pseq([0.1,0.2,0.5,0.7], inf), Pn(0.1,6), 1.3,1], inf),
	\strum, 0.05, // 50 ms strum between notes
).play(t, quant:4);
)

Pbindef(\shimmering).stop;