HouvilainenFilter : UGen {
	*ar { |in, freq, res, filtertype=1|
		^this.multiNew('audio', in, freq, res, filtertype);
	}
	checkInputs {
		^this.checkValidInputs;
	}
}
