////////////////////// System
// Configure the audio server before booting it. Change the device names to match
// your audio interface; the FX bus carries stereo effect sends.
ServerOptions.devices;

(
s = Server.local;
s.options.outDevice_("Babyface Pro (72994168)");
s.options.numOutputBusChannels_(16);
s.options.inDevice_("Babyface Pro (72994168)");
s.options.numInputBusChannels_(8);
s.options.sampleRate_(96000);
s.options.blockSize = 64;
s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;
s.newBusAllocators;
~fxBus = Bus.audio(s, 2);
s.freeAll;
s.waitForBoot({
})
)

////////////////////// Samples Loader
(
// load your sample folder
~loadFolder = { |path|
    PathName(path)
    .entries
    .select({ |sf| sf.isFile })
    .collect({ |sf| Buffer.read(s, sf.fullPath) });
};

d = Dictionary.new;

d[\f] = ~loadFolder.("/Users/fakedac/Music/Samples/squid/");
)

//test your samples
d[\f][0].postln;
d[\f][0].numChannels.postln;


////////////////////// \clock & bpm
(
~currentBPM = 145;
TempoClock.default.tempo = ~currentBPM / 60;

~clockTask = Task({
	inf.do({
		var newBPM = 140 + 60.rand;
		TempoClock.default.tempo = newBPM / 60;
		0.5.wait;
	});
});
)

Tdef(\bpmMonitor, { inf.do({ (TempoClock.default.tempo * 60).postln; 1.wait; }) }).play;

~clockTask.start; // Start the jittery tempo
~clockTask.stop; TempoClock.default.tempo = 145/60; // Reset to 120 BPM
~clockTask.stop; TempoClock.default.tempo = 60/60; // Reset to 60 BPM


////////////////////// \synths
(
SynthDef(\bassDrum, {
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;
    // body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([261, 120, \freq.kr(49)], [0.035, 0.08], curve: \exp));
	bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, \rel.kr(0.3)), doneAction: 2);
    body = SinOsc.ar(bodyFreq) * bodyAmp;
    // pop sweeps over the midrange
    popFreq = XLine.kr(750, 261, 0.02);
    popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
    click = LPF.ar(Formant.ar(210, 4760, 2110), 3140) * clickAmp;
    snd = body + pop + click;
	snd = snd * \amp.kr(1);
    snd = snd.tanh;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\sampler, {
    var sig, env, buf;
    buf = \buf.kr(0);
    sig = PlayBuf.ar(
        numChannels: 2,   // change to 1 if your samples are mono
        bufnum: buf,
        rate: BufRateScale.kr(buf) * \rate.kr(1),
        startPos: \spos.kr(0),
        loop: \loop.ir(0),
        doneAction: 2
    );
    env = EnvGen.kr(Env.perc(\atk.ir(0.002), \rel.ir(0.5), curve: -4), gate: 1);
    sig = Pan2.ar(sig * env * \amp.kr(1), \pan.kr(0));
    Out.ar(\out.kr(0), sig);
}).add;

SynthDef(\fx, {
    var snd, dry, dynamicBitcrush;
    // Add arguments that you want to control from the pattern
    var mix = \mix.kr(1);
    var pitchRate = \pitchRate.kr(3);
    var delayTime = \delayTime.kr(0.1);

    // Read from the input bus provided by Pfxb automatically
    snd = In.ar(\out.kr(0), 2);
    dry = snd; // Save dry signal

    // FX Chain (Using the arguments where appropriate)
    snd = snd + (NHHall.ar(snd * ToggleFF.ar(Dust.ar(8)).lag(0.1), 2) * ToggleFF.ar(Dust.ar(8)).lag(0.1));
    snd = snd + CombC.ar(snd, 0.01, LFNoise1.ar(1, 1, 1.0, 1.0, 30, 100, 0.3, 0.05, 5).range (0.001, 0.01), 0.7);
    snd = snd + CombC.ar(snd, 0.05, Gendy3.kr(6, 4, SinOsc.kr(0.1, 0, 0.49, 0.51), SinOsc.kr(0.13, 0, 0.49, 0.51), freq: 0.7, ampscale: 0.5).range (0.001, 0.05), 0.8);
    snd = snd + CombC.ar(snd, 0.04, LFNoise1.ar(0.1).range(0.005, 0.03), 0.3);

	snd = snd + CombC.ar(snd, 0.04, SinOsc.ar(0.1).range(0.005, 0.03), 0,3);
	snd = DelayC.ar(snd, 0.4, [0.4, 0.3]);

	// Controlled by pattern via pitchRate argument
    snd = PitchShift.ar(snd, 0.15, TExpRand.ar(0.5, 2, Dust.ar(pitchRate))) * 10.dbamp;

	// Generative digital decay distortion (Classic Mego style)
	dynamicBitcrush = LFNoise1.kr(0.3).exprange(0.001, 0.5);
	snd = (snd * Gendy3.ar(6, 4, 0.3, 0.5, freq: 80, ampscale: 0.5, initCPs:2).exprange(1, 5)).round(dynamicBitcrush);
	snd = LeakDC.ar(snd);
	snd = HPF.ar(snd, 40);

    // Controlled by pattern via delayTime argument
    snd = SelectX.ar(ToggleFF.ar(Dust.ar(8)).lag(0.03), [snd, DelayC.ar(snd, 0.2, Gendy3.ar(1, 3, 0.9, 0.9, freq: 0.4, ampscale: 0.5).range(0, delayTime))]);

    snd = Compander.ar(snd, snd, 0.8, 1.0, 0.5, 0.01, 0.1);
    snd = tanh(snd * \makeup.kr(1));
    snd = Limiter.ar(snd, 0.99, 0.02);

    // XFade between dry and completely wet signal
    snd = SelectX.ar(mix, [dry, snd]);

    // Pfxb handles routing, XOut or ReplaceOut works, but ReplaceOut is safest here
    ReplaceOut.ar(\out.kr(0), snd);
}).add;
)



////////////////////// \pattern

// Evaluate this ONCE at the start of your set:
Pdef(\glitchMaster, Pfxb(Pdef(\p1), \fx, \mix, Pdefn(\fxMix, 0.05), \pitchRate, Pdefn(\fxPitch, 3))).play(quant: 4);
Pdef(\ch2, Pfxb(Pbindef(\p2), \fx, \mix, 0.3)).play(quant: 4); // Wet channel

// Now you can manipulate \p1 completely independently without touching the FX container!
Pbindef(\p1, \instrument, \sampler, \dur, 0.25);
Pbindef(\p1, \instrument, \bassDrum, \dur, 1); // Swap instruments on the fly!

// Live improvisation across channels:
Pbindef(\p1, \instrument, \bassDrum, \dur, 0.5, \amp, 0.6); // Stable kick
Pbindef(\p2, \instrument, \sampler, \dur, 0.125, \rate, 2); // Glitchy hats/samples above it




(
Pbindef(\p1,
    \instrument, \bassDrum, // synthetic bassdrum
	\freq, 49,
    \rel, 0.3,
    \pan, Pwrand([0, -0.8, 0.8], [0.7, 0.15, 0.15], inf),
	\dur, 0.4,
    \amp, Pwhite(0.45, 0.55),
);

Pbindef(\p2,
    \instrument, \sampler, // Changed to match your SynthDef name
    \buf, Pwrand([d[\f].choose, \r, d[\f].choose, d[\f].choose, d[\f].choose, \r, \r], [0.7, 0.15, 0.15, 0.25, 0.1, 0.1, 0.2].normalizeSum, inf),
    \rate, 0.75,
    \spos, Pwrand([0, 0.4, 0.8], [0.7, 0.15, 0.15], inf),
    \rel, 0.5,
    \pan, Pwrand([0, -0.8, 0.8], [0.7, 0.15, 0.15], inf),
	\dur, 0.2,
    \amp, Pwhite(0.45, 0.55),
);

// Wrap your pattern inside Pfxb to pass FX parameters
Pdef(\sequencedPattern,
    Pfxb(
		Pbindef(\p2),
        \fx,
        // Sequence your FX parameters here!
        \mix, 0.1, // Pseq([0.75, 0, 1, 0.5], inf), // Pseq([0, 0.2, 0.5, 1], inf), // Slowly brings the effect chain in/out
        \pitchRate, Pseq([0.5, 3, 0.12, 0.4], inf), // Drastically alters the PitchShift stutter rate per step
        \delayTime, Pwhite(0.01, 0.025) // Randomizes glitch delay time per step
    )
).play(quant: 4);
)

Pbindef(\p1).play;
Pbindef(\p2).play;
Pdef(\sequencedPattern).play;
