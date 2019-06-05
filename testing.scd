(
{
  var freq = Lag2.ar(Demand.ar(Impulse.ar(LFNoise0.kr(0.5).range(0.1, 1)), 0, Dseq([100, 66.666, 50, 75], inf)), 0.1);
  var sig = Saw.ar(freq) * 0.1;
  sig = sig + (Saw.ar(freq + 1) * 0.1);
  sig = sig + (Pulse.ar(freq / 2) * 0.05);
  //sig = PinkNoise.ar(0.6);
  sig = HouvilainenFilter.ar(sig, Lag2.ar(LFNoise0.ar(3.6).exprange(25, 22000), 0.05) + (SinOsc.ar(150).range(-150, 150) * LFNoise1.kr(0.5).range(0, 1)), LFNoise2.kr(LFNoise1.kr(0.5).exprange(0.1, 10)).range(0.5, 0.93), 3);
  sig = Limiter.ar(sig, 0.2);
  sig = LeakDC.ar(sig);
  sig = sig + AllpassC.ar(sig, 0.2777, [0.17, 0.2777], 10, 0.1);
  sig = sig + AllpassC.ar(sig, 1.0, [0.2777 * 2, 0.27777 * 3], 10, 0.2);
  //sig = sig + SinOsc.ar(MouseX.kr(25, 22000, \exponential), 0, 0.1);
}.play
)
s.reboot

s.sampleRate

2843465.5661095 * (-2) * pi * 1801
1.873 * (114.84375.pow(3)) + (0.4955 * (114.84375.squared)) - (0.649 * 114.84375) + 1.4
1000 * (44100 / 192000) * 0.5
48000 * 4

{SampleRate.ir.poll}.play


(
~oscs = { |freq, slop, pw = 0.5|
  var rate = freq + LFNoise1.ar(LFNoise1.kr(1).range(0.2, 0.3), mul: slop * (freq / 1000));
  var phase = Phasor.ar(0, rate, 0, SampleRate.ir) * 2pi / SampleRate.ir;
  var duty = (pw - 0.5).sign * (pw - 0.5).abs.lincurve(0, 0.5, 0, 0.5, 5);
  var dutyPhase = phase.lincurve(0, 2pi, 0, 2pi, duty.linlin(-0.5, 0.5, -85, 85));
  var k = 12000 * (SampleRate.ir/44100) / (freq * log10(freq));
  var sinSig = SinOsc.ar(0, phase);
  var dutySinSig = SinOsc.ar(0, dutyPhase);
  var cosSig = SinOsc.ar(0, phase + (pi/2));
  var sqSig = tanh(sinSig * k);
  var dutySqSig = tanh(dutySinSig * k);
  var sawSig = dutySqSig * (cosSig + 1) * 0.5;
  var sawPw = (pw - 0.5).abs.lincurve(0, 0.5, 0, 0.5, 2);
  var triSig = VarSaw.ar(rate, 0, sawPw);
  var dutySawSig = LinSelectX.ar(sawPw.lincurve(0, 0.5, 0, 1, -7), [sawSig + Saw.ar(rate), triSig * 1.5]);
  [dutySawSig, dutySqSig * 1.5, dutySinSig + VarSaw.ar(rate, 0.25, 0.5)];
};

x = { |freq = 100, slop = 0.01, portamento = 0.2|
  var sigs, sig;
  freq = Lag2.kr(freq, portamento);
  freq = freq * LFNoise2.kr(0.5).range(0.995, 1.005);
  freq = freq * VarSaw.kr(LFNoise2.kr(0.5).range(4, 7)).range(0.995, 1.005);
  sigs = ~oscs.(freq, slop);
  sig = sigs[0] * 0.05;
  sigs = ~oscs.(freq / 2, slop, 0.5);
  sig = sig + (sigs[2] * 0.05);
  sigs = ~oscs.(freq + 1, slop);
  sig = sig + (sigs[0] * 0.02);
  //var sig = Saw.ar(100) * 0.1;
  //sig = sig + (Saw.ar(101) * 0.1);
  //sig = sig + (Pulse.ar(50) * 0.05);
  //sig = PinkNoise.ar(0.6);
  sig = HouvilainenFilter.ar(sig, K2A.ar(MouseX.kr(25, 22000, \exponential)) + Saw.ar(freq).range(-1 * freq, freq), K2A.ar(MouseY.kr(0, 1).lincurve(0, 1, 0, 1, -2).poll), 1);
  sig = LeakDC.ar(sig);
  sig = sig + AllpassC.ar(sig, 0.2, [0.17, 0.2], 10, 0.1);
  sig = sig + AllpassC.ar(sig, 1.0, [1.0, 0.7], 10, 0.2);
  //sig = sig + SinOsc.ar(MouseX.kr(25, 22000, \exponential), 0, 0.1);
}.play
)

(
MIDIClient.init;
MIDIIn.connectAll;

k = MIDIIn.findPort("microKEY2", "KEYBOARD");
MIDIdef.noteOn(\korgOn, { |vel, num|
  x.set(\freq, num.midicps);
}, srcID: k.uid);
MIDIdef.noteOff(\korgOff, { |vel, num|
}, srcID: k.uid);
MIDIdef.cc(\korgCC, { |val, num|
  if (num == 1) {
    x.set(\portamento, val.linexp(0, 127, 0.01, 5));
  };
}, srcID: k.uid);
MIDIdef.bend(\korgBend, { |val|
}, srcID: k.uid);
)
