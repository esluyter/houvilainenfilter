HouvilainenFilter : Filter {
	*ar { |in, freq = 1000, res = 0, filtertype = 1|
		freq = freq.expexp(25, 22000, 0.001, 0.588);
		^this.multiNew('audio', in, freq, res, filtertype);
	}
}
