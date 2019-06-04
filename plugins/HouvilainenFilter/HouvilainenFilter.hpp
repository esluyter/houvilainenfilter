// PluginHouvilainenFilter.hpp
// Eric Sluyter (wondersluyter@gmail.com)

#pragma once

#include "SC_PlugIn.hpp"
#include "FilterHandler.h"

namespace HouvilainenFilter {

class HouvilainenFilter : public SCUnit
{
public:
    HouvilainenFilter();

    // Destructor
    ~HouvilainenFilter();

private:
    // Calc function
    void next(int nSamples);

    // Member variables
    FilterHandler *filterHandler;
};

} // namespace HouvilainenFilter
