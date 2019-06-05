HouvilainenFilter : UGen {
	*ar { |in, freq, res, filtertype=1|
		freq = freq.expexp(25, 22000, 0.001, 0.588);
		^this.multiNew('audio', in, freq, res, filtertype);
	}
	checkInputs {
		^this.checkValidInputs;
	}
}
