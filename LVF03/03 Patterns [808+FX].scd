////////////////////// \system
ServerOptions.devices;

(
s = Server.local;
ServerOptions.devices;
s.options.outDevice_("Babyface Pro (72994168)");
s.options.numOutputBusChannels_(12);
 s.options.inDevice_("Babyface Pro (72994168)");
s.options.numInputBusChannels_(4);
s.options.sampleRate_(48000);
s.options.blockSize = 64;
s.options.numBuffers = 1024 * 16;
s.options.memSize = 8192 * 128;
s.scope;
s.meter;
s.freeAll;
s.waitForBoot({
})
)

////////////////////// \clock
t = Task({ inf.do({ Tempo.bpm = 44 + 140.rand; 0.1.wait; });});
t = Task({ inf.do({ Tempo.bpm = 40 + 40.rand; 0.1.wait; });});

t.start;
t.stop; Tempo.bpm = 142;
t.stop; Tempo.bpm = 60;

////////////////////// \808
(
SynthDef.new(\bd808, {
	var fenv, env, trienv, sig, sub, punch, pfenv;
	env = EnvGen.kr(Env.new([0.11, 1, 0], [0, \decay.kr(30)], -225),doneAction:2);
	trienv = EnvGen.kr(Env.new([0.11, 0.6, 0], [0, \decay.kr(30)], -230),doneAction:0);
	fenv = Env([\tone.kr(56)*7, \tone.kr(56)*1.35, \tone.kr(56)], [0.05, 0.6], -14).kr;
	pfenv = Env([\tone.kr(56)*7, \tone.kr(56)*1.35, \tone.kr(56)], [0.03, 0.6], -10).kr;
	sig = SinOsc.ar(fenv, pi/2) * env;
	sub = LFTri.ar(fenv, pi/2) * trienv * 0.05;
	punch = SinOsc.ar(pfenv, pi/2) * env * 2;
	punch = HPF.ar(punch, 350);
	sig = (sig + sub + punch) * 2.5;
	sig = Limiter.ar(sig, 0.5) * \amp.kr(2);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\sn808, {
	var noiseEnv, atkEnv, sig, noise, osc1, osc2, sum;
	noiseEnv = EnvGen.kr(Env.perc(0.001, 4.2, 1, -115), doneAction:2);
	atkEnv = EnvGen.kr(Env.perc(0.001, 0.8,curve:-95), doneAction:0);
	noise = WhiteNoise.ar;
	noise = HPF.ar(noise, 1800);
	noise = LPF.ar(noise, 8850);
	noise = noise * noiseEnv * \snappy.kr(0.3);
	osc1 = SinOsc.ar(\tone2.kr(189), pi/2) * 0.6;
	osc2 = SinOsc.ar(\tone.kr(340), pi/2) * 0.7;
	sum = (osc1+osc2) * atkEnv * \amp2.kr(1);
	sig = Pan2.ar((noise + sum) * \amp.kr(2) * 2.5, \pan.kr(0));
	sig = HPF.ar(sig, 340);
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\cpRaw808, {
	var atkenv, atk, decay, sum, denv;
	atkenv = EnvGen.kr(Env.new([0.5,1,0],[0, 0.3], -160), doneAction:2);
	denv = EnvGen.kr(Env.dadsr(0.026, 0, 6, 0, 1, 1, curve:-157), doneAction:0);
	atk = WhiteNoise.ar * atkenv * 1.4;
	decay = WhiteNoise.ar * denv;
	sum = atk + decay * \amp.kr(1);
	sum = HPF.ar(sum, 500);
	sum = BPF.ar(sum, 1062, 0.5);
	Out.ar(\out.kr(0), Pan2.ar(sum * 1.5, \pan.kr(0)));
}).add;

SynthDef.new(\cpReverb808, {
	var reverb, revgen;
	revgen = EnvGen.kr(Env.perc(0.1, 4, curve:-9), \gate.kr(1), doneAction:2);
	reverb = WhiteNoise.ar * revgen * 0.02;
	reverb = HPF.ar(reverb, 500);
	reverb = LPF.ar(reverb, 1000);
	Out.ar(\out.kr(0), Pan2.ar(reverb * \amp.kr(1), \pan.kr(0)));
}).add;

SynthDef.new(\LT808, {
	var sig, fenv, env, pnoise, penv;
	env = EnvGen.kr(Env.new([0.4, 1, 0], [0, 20], -250),doneAction:2);
	penv = EnvGen.kr(Env.new([0.6, 1, 0], [0, 30], -225),doneAction:2);
	fenv = Env([\freq.kr(80)*1.25, \freq.kr(80)*1.125, \freq.kr(80)], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2) * env;
	sig = Pan2.ar(sig * \amp.kr(1) * 3, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\MT808, {
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.4, 1, 0], [0, 16], -250),doneAction:2);
	fenv = Env([\freq.kr(120)*1.33333, \freq.kr(120)*1.125, \freq.kr(120)], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * \amp.kr(1) * 2, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\HT808, {
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.4, 1, 0], [0, 11], -250),doneAction:2);
	fenv = Env([\freq.kr(165)*1.333333, \freq.kr(165)*1.121212, \freq.kr(165)], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * \amp.kr(1) * 2, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\LC808, {
	var sig, fenv, env, pnoise, penv;
	env = EnvGen.kr(Env.new([0.15, 1, 0], [0, 18], -250),doneAction:2);
	penv = EnvGen.kr(Env.new([0.6, 1, 0], [0, 30], -225),doneAction:2);
	fenv = Env([\freq.kr(165)*1.333333, \freq.kr(165)*1.121212, \freq.kr(165)], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2) * env;
	sig = Pan2.ar(sig * \amp.kr(1) * 3, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\MC808, {
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.15, 1, 0], [0, 9], -250),doneAction:2);
	fenv = Env([ \freq.kr(250)*1.24, \freq.kr(250)*1.12, \freq.kr(250)], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * \amp.kr(1) * 2, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\HC808, {
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.15, 1, 0], [0, 6], -250),doneAction:2);
	fenv = Env([\freq.kr(370)*1.22972, \freq.kr(370)*1.08108, \freq.kr(370)], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * \amp.kr(1) * 2, \pan.kr(0) );
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\rimshot808, {
	var fenv, env, sig, punch, tri1, tri2;
	env = EnvGen.kr(Env.new([1, 1, 0], [0.00272, 0.07], -42), doneAction:2);
	tri1 = LFTri.ar(1667 * 1.1, 1) * env;
	tri2 = LFPulse.ar(455 * 1.1, width:0.8) * env;
	punch = WhiteNoise.ar * env * 0.46;
	sig = tri1 + tri2 + punch;
	sig = BPeakEQ.ar(sig, 464, 0.44, 8);
	sig = HPF.ar(sig, 315);
	sig = LPF.ar(sig, 7300);
	sig = Pan2.ar(sig * \amp.kr(1), \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\claves808, {
	var  env, sig;
	env = EnvGen.kr(Env.new([1, 1, 0], [0, 0.1], -20), doneAction:2);
	sig = SinOsc.ar(2500, pi/2) * env * \amp.kr(1);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\maracas808, {
	var env, sig;
	env = EnvGen.kr(Env.new([0.3, 1, 0], [0.027, 0.07], -250), \gate.kr(1), doneAction:2);
	sig = WhiteNoise.ar * env * \amp.kr(1);
	sig = HPF.ar(sig, 5500);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\cowbell808, {
	var sig, pul1, pul2, env, atk, atkenv, datk;
	atkenv = EnvGen.kr(Env.perc(0, 1, 1, -215),doneAction:0);
	env = EnvGen.kr(Env.perc(0.01, 9.5, 1, -90),doneAction:2);
	pul1 = LFPulse.ar(811.16);
	pul2 = LFPulse.ar(538.75);
	atk = (pul1 + pul2) * atkenv * 6;
	datk = (pul1 + pul2) * env;
	sig = (atk + datk) * \amp.kr(1);
	sig = HPF.ar(sig, 250);
	sig = LPF.ar(sig, 4500);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\hat808, {
	var sig, sighi,siglow, sum, env, osc1, osc2, osc3, osc4, osc5, osc6;
	env = EnvGen.kr(Env.perc(0.005, \decay.kr(0.42), 1, -30),doneAction:2);
	osc1 = LFPulse.ar(203.52);
	osc2 = LFPulse.ar(366.31);
	osc3 = LFPulse.ar(301.77);
	osc4 = LFPulse.ar(518.19);
	osc5 = LFPulse.ar(811.16);
	osc6 = LFPulse.ar(538.75);
	sighi = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    siglow = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    sighi = BPF.ar(sighi, 8900, 1);
    sighi = HPF.ar(sighi, 9000);
    siglow = BBandPass.ar(siglow, 8900, 0.8);
    siglow = BHiPass.ar(siglow, 9000, 0.3);
    sig = BPeakEQ.ar((siglow+sighi), 9700, 0.8, 0.7);
    sig = sig * env * \amp.kr(1);
    sig = Pan2.ar(sig, \pan.kr(0));
    Out.ar(\out.kr(0), sig);
}).add;

SynthDef.new(\openhihat808, {
	var sig, siga, sigb, env1, env2, osc1, osc2, osc3, osc4, osc5, osc6, sum;
	env1 = EnvGen.kr(Env.perc(0.1, \decay.kr(0.5), curve:-3), doneAction:2);
	env2 = EnvGen.kr(Env.new([0, 1, 0], [0, \decay.kr(0.5)*5], curve:-150), doneAction:0);
	osc1 = LFPulse.ar(203.52) * 0.6;
	osc2 = LFPulse.ar(366.31) * 0.6;
	osc3 = LFPulse.ar(301.77) * 0.6;
	osc4 = LFPulse.ar(518.19) * 0.6;
	osc5 = LFPulse.ar(811.16) * 0.6;
	osc6 = LFPulse.ar(538.75) * 0.6;
	sig = osc1 + osc2 + osc3 + osc4 + osc5 +osc6;
	sig = BLowShelf.ar(sig, 990, 2, -3);
	sig = BPF.ar(sig, 7700);
	sig = BPeakEQ.ar(sig, 7200, 0.5, 5);
	sig = BHiPass4.ar(sig, 8100, 0.7);
	sig = BHiShelf.ar(sig, 9400, 1, 5);
	siga = sig * env1 * 0.6;
	sigb = sig * env2;
	sum = siga + sigb;
	sum = LPF.ar(sum, 4000);
	sum = Pan2.ar(sum, \pan.kr(0));
	sum = sum * \amp.kr(4) * 2;
	Out.ar(\out.kr(0), sum);
}).add;

SynthDef.new(\cymbal808, {
	var sig, sig1,sig2, sig2a, sig2b, sig3, env1, env2, env2b, env3, osc1, osc2, osc3, osc4, osc5, osc6, sum;
	env1 = EnvGen.kr(Env.perc(0.3, \decay.kr(2), curve:-3), doneAction:2);
	env2 = EnvGen.kr(Env.new([0, 0.6, 0], [0.1, \decay.kr(2)*0.7], -5), doneAction:0);
	env2b = EnvGen.kr(Env.new([0, 0.3, 0], [0.1, \decay.kr(2)*20], -120), doneAction:0);
	env3 = EnvGen.kr(Env.new([0, 1, 0], [0, \decay.kr(2)*5], curve:-150), doneAction:0);
	osc1 = LFPulse.ar(203.52) * 0.6;
	osc2 = LFPulse.ar(366.31) * 0.6;
	osc3 = LFPulse.ar(301.77) * 0.6;
	osc4 = LFPulse.ar(518.19) * 0.6;
	osc5 = LFPulse.ar(811.16) * 0.6;
	osc6 = LFPulse.ar(538.75) * 0.6;
	sig = osc1 + osc2 + osc3 + osc4 + osc5 +osc6;
	sig1 = BLowShelf.ar(sig, 2000, 1, 5);
	sig1 = BPF.ar(sig1, 3000);
	sig1 = BPeakEQ.ar(sig1, 2400, 0.5, 5);
	sig1 = BHiPass.ar(sig1, 1550, 0.7);
	sig1 = LPF.ar(sig1, 3000);
	sig1 = BLowShelf.ar(sig1, 1000, 1, 0);
	sig1 = sig1 * env1 * \tone.kr(0.002);
	sig2 = BLowShelf.ar(sig, 990, 2, -5);
	sig2 = BPF.ar(sig2, 7400);
	sig2 = BPeakEQ.ar(sig2, 7200, 0.5, 5);
	sig2 = BHiPass4.ar(sig2, 6800, 0.7);
	sig2 = BHiShelf.ar(sig2, 10000, 1, -4);
	sig2a = sig2 * env2 * 0.3;
	sig2b = sig2 * env2b * 0.6;
	sig3 = BLowShelf.ar(sig, 990, 2, -15);
	sig3 = BPF.ar(sig3, 6500);
	sig3 = BPeakEQ.ar(sig3, 7400, 0.35, 10);
	sig3 = BHiPass4.ar(sig3, 10500, 0.8, 2);
	sig3 = sig3 * env3;
	sum = sig1 + sig2a + sig2b + sig3;
	sum = LPF.ar(sum, 4000);
	sum = Pan2.ar(sum, \pan.kr(0));
	sum = sum * \amp.kr(20);
	Out.ar(\out.kr(0), sum);
}).add;
)

////////////////////// \pattern #1
(
Pbindef(
	\bd,
	\instrument, \bd808,
	\tone, 56,
	\decay, 30,
	\amp, 0.75,
	\pan, 0,
	\out, 0,
	\dur, 0.5 * Pbjorklund2(Pwhite(9,15),16, inf),
).play(quant:4);

Pbindef(
	\sn,
	\instrument, \sn808,
	\tone, 340,
	\tone2, 189,
	\snappy, 0.75,
	\amp, 0.25,
	\pan, 0,
	\out, 0,
	\dur, 1 * Pbjorklund2(Pwhite(7,11),16, inf),
).play(quant:4);

Pbindef(
	\cb,
	\instrument, \cymbal808,
	\decay, 2,
	\amp, 2,
	\pan, 0,
	\out, 0,
	\dur, 4,
).play(quant:4);

Pbindef(
	\hh,
	\instrument, \hat808,
	\decay, Prand([0.1, 0.5, 0.2, 0.15], inf),
    \pan, 0,
	\amp, 1,
	\out, 0,
	\dur, 1 * 0.25,
).play(quant:4);

Pbindef(
	\ohh,
	\instrument, \openhihat808,
    \decay, 0.5,
    \amp, 1,
    \pan, 0,
	\out, 0,
	\dur, 3,
).play(quant:4);
)

////////////////////// \stop
(
Pbindef(\bd).clear;
Pbindef(\sn).clear;
Pbindef(\cp).clear;
Pbindef(\hh).clear;
Pbindef(\ohh).clear;
)
