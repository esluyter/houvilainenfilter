
(
x = { |type = 1, portamento = 0.2, audioMod = 0|
  var sig, baseFreq;
  var freq = \freq.kr(100, portamento);
  freq = freq + LFNoise2.kr(LFNoise1.kr(1).exprange(0.2, 2)).range(freq * 0.98, freq * 1.02);
  baseFreq = freq;
  sig = DC.ar(0);
  [1, 2, 3, 5, 8].do { |n|
    freq = baseFreq * n;
    sig = sig +  Splay.ar(Saw.ar({ LFNoise2.kr(0.5).range(freq - 1, freq + 1) } ! 2), 0.2)
    + Pulse.ar(freq / 2, 0.5, LFNoise2.kr(0.5).exprange(0.01, 1));
  };
  HouvilainenFilter.ar(
    sig,
    MouseX.kr(100, 10000, \exponential)
    + (SinOsc.ar(LFNoise2.kr(LFNoise1.kr(1).range(0.5, 5)).exprange(0.001, 5000)).range(-100, 100) * audioMod),
    MouseY.kr,
    type
  );
}.play
)
s.options.outDevice = "Built-in Output"
s.options.inDevice = "Aggregate Device"
s.options.sampleRate = nil
s.reboot
x.set(\type, 3)
x.set(\freq, 25);
x.set(\audioMod, 1)

SCDoc.indexAllDocuments(true)


(
SynthDef(\filterdemo, { |out, res = 0.8, gate = 1, amp = 0.1, filtrange = 10, noiseamt = 0.5, type = 1, subamt = 0.5, ampmod = 0, audiomod = 0|
  var pan = \pan.kr(0) + SinOsc.kr(LFNoise1.kr(0.5).exprange(0.1, 1), 0, \panmod.kr(0));
  var freq = \freq.kr(440) * LFNoise2.kr(LFNoise1.kr(0.5).exprange(0.3, 0.9)).range(0.99, 1.01);
  var sig = Splay.ar(Saw.ar([freq, freq + 1]) + HPF.ar(PinkNoise.ar(noiseamt!2), freq), 0.4, center: pan) + Pan2.ar(Pulse.ar(freq / 2, 0.5, subamt), pan / 3);
  var cutoff = Env.adsr(5, 7, 0.5, 5).kr(0, gate).linexp(0, 1, freq, freq * filtrange);
  amp = Env.adsr(7, 10, 0.2, 10).kr(1, gate, levelScale: amp) * SinOsc.ar(LFNoise1.kr(0.5).range(3, 6)).range(1, 1 - ampmod);
  sig = HouvilainenFilter.ar(sig, cutoff + (SinOsc.ar(LFNoise2.kr(LFNoise1.kr(1).range(0.5, 5)).exprange(0.001, 1000)).range(-100, 100) * audiomod), res, type) * amp;
  Out.ar(out, sig);
}).add;
)

(
x = {
  var sig = In.ar(0, 2);
  sig = sig + LPF.ar(AllpassC.ar(sig, 0.2, [0.17, 0.2], 10, 0.2), 8000);
  sig = sig + LPF.ar(AllpassC.ar(sig, 1.0, [1.0, 0.7], 10, 0.3), 5000);
  ReplaceOut.ar(0, sig);
}.play;

Pbind(
  \instrument, \filterdemo,
  \midinote, Prand([38, 50, 57, 62, 64, 66, 68, 69, 72, 74], inf),
  \dur, Pwhite(0.5, 8),
  \legato, Pwhite(1.0, 5.0),
  \res, Pwhite(0, 0.95),
  \db, Pkey(\midinote).linlin(38, 66, -6, -12) + Pwhite(-3.0, 3.0),
  \filtrange, Pkey(\midinote).linlin(38, 66, 15, 6) + Pwhite(-5, 5),
  \noiseamt, Pwhite(0.0, 1.0),
  \type, Pwhite(1, 4),
  \pan, Pwhite(-1.0, 1.0),
  \subamt, Pkey(\midinote).linlin(38, 74, 0.8, 0.2) + Pwhite(-0.2, 0.4),
  \ampmod, Pwhite(0.0, 1).linexp(0, 1, 0.001, 1) * Pkey(\midinote).linlin(38, 66, 0.1, 1),
  \audiomod, (Pbrown(0.0, 1.0, 0.5) + Pwhite(-0.2, 0.2)).linexp(0, 1, 0.01, 2).trace,
  \panmod, Pwhite(0.0, 1.0) * Pkey(\midinote).linexp(38, 74, 0.1, 1)
).play
)