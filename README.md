# SimplePlot

[![Build Status](https://travis-ci.org/slundberg/SimplePlot.jl.svg?branch=master)](https://travis-ci.org/slundberg/SimplePlot.jl)

This is currently just a simple collection of plotting methods that I needed for a paper. I wanted to customize the plots more than is currently possible with Gadfly, so it is currently based on PyPlot (which uses matplotlib). Hopefully at some point in the future Gadfly can replace PyPlot.

## Usage

```julia
SimplePlot.bar(
    x = ["G1", "G2", "G3", "G4", "G1", "G2", "G3", "G4"],
    y = [3,6,2,4,8,3,5,1],
    color = ["A", "A", "A", "A", "B", "B", "B", "B"]
)
```
