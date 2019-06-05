// PluginHouvilainenFilter.cpp
// Eric Sluyter (wondersluyter@gmail.com)

#include "SC_PlugIn.hpp"
#include "FilterHandler.h"
#include "HouvilainenFilter.hpp"

static InterfaceTable *ft;

namespace HouvilainenFilter {

HouvilainenFilter::HouvilainenFilter()
{
    filterType = in0(3);
    filterHandler = new FilterHandler(sampleRate());
    filterHandler->setFiltertype(filterType);
    filterHandler->reset();

    if (isAudioRateIn(1)) {
        set_calc_function<HouvilainenFilter, &HouvilainenFilter::next_a>();
    } else {
        set_calc_function<HouvilainenFilter, &HouvilainenFilter::next_k>();
    }
    // set_calc_function already calculates sample
    //next(1);
}

HouvilainenFilter::~HouvilainenFilter()
{
    delete filterHandler;
}

void HouvilainenFilter::next_a(int nSamples)
{
    const float * input = in(0);
    const float * cutoff = in(1);
    const float resonance = in0(2);
    const float filterTypeIn = in0(3);
    float * outbuf = out(0);

    if (filterTypeIn != filterType) {
        filterType = filterTypeIn;
        filterHandler->setFiltertype(filterType);
    }

    for (int i = 0; i < nSamples; ++i) {
        outbuf[i] = filterHandler->process(input[i], cutoff[i], resonance);
    }
}

void HouvilainenFilter::next_k(int nSamples)
{
    const float * input = in(0);
    const float cutoff = in0(1);
    const float resonance = in0(2);
    const float filterTypeIn = in0(3);
    float * outbuf = out(0);

    if (filterTypeIn != filterType) {
        filterType = filterTypeIn;
        filterHandler->setFiltertype(filterType);
    }

    for (int i = 0; i < nSamples; ++i) {
        outbuf[i] = filterHandler->process(input[i], cutoff, resonance);
    }
}

} // namespace HouvilainenFilter

PluginLoad(HouvilainenFilterUGens) {
    // Plugin magic
    ft = inTable;
    registerUnit<HouvilainenFilter::HouvilainenFilter>(ft, "HouvilainenFilter");
}
