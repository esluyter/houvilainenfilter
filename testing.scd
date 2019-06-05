(
{
  var sig = Saw.ar(100) * 0.1;
  sig = sig + (Saw.ar(101) * 0.1);
  sig = sig + (Pulse.ar(50) * 0.05);
  sig = PinkNoise.ar(0.6);
  sig = HouvilainenFilter.ar(sig, K2A.ar(MouseX.kr(25, 22000, \exponential).poll), K2A.ar(MouseY.kr(0, 1)), 3);
  sig = LeakDC.ar(sig);
  sig = sig + AllpassC.ar(sig, 0.2, [0.17, 0.2], 10, 0.1);
  sig = sig + AllpassC.ar(sig, 1.0, [1.0, 0.7], 10, 0.2);
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

