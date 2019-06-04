// PluginHouvilainenFilter.cpp
// Eric Sluyter (wondersluyter@gmail.com)

#include "SC_PlugIn.hpp"
#include "FilterHandler.h"
#include "HouvilainenFilter.hpp"

static InterfaceTable *ft;

namespace HouvilainenFilter {

HouvilainenFilter::HouvilainenFilter()
{
    filterHandler = new FilterHandler(sampleRate());
    filterHandler->setFiltertype(in0(3));
    filterHandler->reset();
    set_calc_function<HouvilainenFilter, &HouvilainenFilter::next>();
    // set_calc_function already calculates sample
    //next(1);
}

HouvilainenFilter::~HouvilainenFilter()
{
    delete filterHandler;
}

void HouvilainenFilter::next(int nSamples)
{
    const float * input = in(0);
    const float * cutoff = in(1);
    const float * resonance = in(2);
    float * outbuf = out(0);

    for (int i = 0; i < nSamples; ++i) {
        outbuf[i] = input[i];
        Print("Sample: %f\n", filterHandler->process(input[i], cutoff[i], resonance[i]));
    }
}

} // namespace HouvilainenFilter

PluginLoad(HouvilainenFilterUGens) {
    // Plugin magic
    ft = inTable;
    registerUnit<HouvilainenFilter::HouvilainenFilter>(ft, "HouvilainenFilter");
}
