/////////////////////////////////////////////////////
// SuperCollider – Server and UGens Tutorial
/////////////////////////////////////////////////////
// Luis Sanz | Aug 2025 | www.luissanz.ch
/////////////////////////////////////////////////////


////////// 1. SuperCollider as Two Programs

/*
SuperCollider actually consists of TWO main parts:

1. sclang (the Language)
   - Object-oriented programming language
   - Class library
   - Interpreter that runs your code

2. scsynth (the Server)
   - Real-time audio synthesis engine
   - Communicates via OSC (Open Sound Control) over UDP/TCP (User Datagram Protocol/Transmission Control Protocol)
   - Plays and processes ALL audio

⚡ Important:
- The language (client) sends OSC messages to the server.
- You can control a server running on another computer.
- Multiple clients can connect to one server (e.g., in laptop ensemble performances).
*/


////////// 2. Booting and Quitting the Server

// Start the local audio server:
Server.local.boot;

// Post Window will show:
// - available audio devices
// - input/output devices
// - sample rate
// - status indicator (bottom-right): CPU usage, server status

// Stop the server:
Server.local.quit;

// Shortcut: use the global variable "s" (convention for local server)
s.boot;   // boot server
s.quit;   // quit server

// ⚠️ Do NOT overwrite "s" — it’s reserved for the local server

// Menu alternative: Language → Boot Server (shortcut Cmd + b)


////////// 3. Playing Sound – Functions and Synths

// Easiest sound:
{ SinOsc.ar }.play;

// {} = Function
// .play sends the Function to the server as a Synth

// Stop all sound: Cmd + Period (.)

// Store a Synth in a variable to control it:
x = { SinOsc.ar }.play;
x.free;   // stop this Synth

// Common mistake:
x = { SinOsc.ar };   // only stores the Function, NOT a Synth
x.play;              // plays but does not store the Synth
x.free;              // ❌ won’t work

// Correct way:
x = { SinOsc.ar };   // Function
y = x.play;          // Synth (stored in y)
y.free;              // now works


////////// 4. Understanding UGens

/*
UGens = Unit Generators (building blocks of sound)

- Generate or process signals
- Always end with a rate suffix:
  .ar → Audio rate (runs at sample rate, e.g. 44,100 Hz)
  .kr → Control rate (runs 64x slower, CPU friendly)
  .ir → Initialization rate (computed once at start)
*/

// Example: basic sine wave
{ SinOsc.ar(440, 0, 0.125, 0) }.play;

// Arguments for SinOsc.ar:
// 1. freq  → frequency (Hz)
// 2. phase → starting phase (radians)
// 3. mul   → multiply (amplitude)
// 4. add   → offset

// Defaults: SinOsc.ar(freq=440, phase=0, mul=1, add=0)

// You can skip arguments using keywords:
{ SinOsc.ar(700, mul:0.125) }.play;

// Equivalent using math:
{ SinOsc.ar(700) * 0.125 }.play;


////////// 5. Functions with Arguments

// Declare arguments inside the function with "arg":
(
z = {
    arg freq=440, amp=1;   // default values
    var sig;
    sig = SinOsc.ar(freq) * amp;
}.play;
)

// Change arguments dynamically:
z.set(\freq, 330);                // change frequency
z.set(\amp, 0.125);               // change amplitude
z.set(\freq, 660, \amp, 1);       // multiple args at once

// Free the Synth:
z.free;


////////// 6. Controlling UGens with Other UGens

// Example: frequency modulation with LFNoise0
(
z = {
    var freq, sig;
    freq = LFNoise0.kr(8, 400, 600); // 8 random values/sec, range = 200–1000 Hz
    sig = SinOsc.ar(freq) * 0.2;
}.play;
)

// Alternative with .range:
(
z = {
    var freq, sig;
    freq = LFNoise0.kr(8).range(200, 1000);  // map -1..1 → 200..1000
    sig = SinOsc.ar(freq) * 0.2;
}.play;
)

// Exponential mapping:
(
z = {
    var freq, sig;
    freq = LFNoise0.kr(8).exprange(200, 1000);  // exponential distribution
    sig = SinOsc.ar(freq) * 0.2;
}.play;
)


// Example: controlling amplitude with LFNoise1
(
z = {
    var freq, amp, sig;
    freq = LFNoise0.kr(8).exprange(200, 1000);
    amp  = LFNoise1.kr(12).exprange(0.02, 1); // smooth random amplitude
    sig = SinOsc.ar(freq) * amp;
}.play;
)

z.free;


// Example: using arguments to control noise speed
(
z = {
    arg noiseHz=8;
    var freq, amp, sig;
    freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
    amp  = LFNoise1.kr(12).exprange(0.02, 1);
    sig = SinOsc.ar(freq) * amp;
}.play;
)

// Change argument on the fly:
z.set(\noiseHz, 16);
z.set(\noiseHz, exprand(4,64));

z.free;


////////// Tips
/*
- Always store Synths in variables if you want to stop them later.
- Use .ar for audible UGens, .kr for control UGens.
- Explore Help files for each UGen (Cmd + D).
- Use .range or .exprange for mapping control signals.
- Use arguments + .set for live performance control.
*/
