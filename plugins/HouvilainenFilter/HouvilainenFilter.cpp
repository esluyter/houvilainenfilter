// PluginHouvilainenFilter.cpp
// Eric Sluyter (wondersluyter@gmail.com)

#include "SC_PlugIn.hpp"
#include "HouvilainenFilter.hpp"

static InterfaceTable *ft;

namespace HouvilainenFilter {

HouvilainenFilter::HouvilainenFilter()
{
    set_calc_function<HouvilainenFilter, &HouvilainenFilter::next>();
    next(1);
}

void HouvilainenFilter::next(int nSamples)
{
    const float * input = in(0);
    const float * gain = in(0);
    float * outbuf = out(0);

    // simple gain function
    for (int i = 0; i < nSamples; ++i) {
        outbuf[i] = input[i] * gain[i];
    }
}

} // namespace HouvilainenFilter

PluginLoad(HouvilainenFilterUGens) {
    // Plugin magic
    ft = inTable;
    registerUnit<HouvilainenFilter::HouvilainenFilter>(ft, "HouvilainenFilter");
}
