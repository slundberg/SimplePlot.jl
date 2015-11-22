# SimplePlot

[![Build Status](https://travis-ci.org/slundberg/SimplePlot.jl.svg?branch=master)](https://travis-ci.org/slundberg/SimplePlot.jl)

This is currently just a simple collection of plotting methods that I needed for a paper. I wanted to customize the plots more than is currently possible with Gadfly, so it is currently based on PyPlot (which uses matplotlib). Hopefully at some point in the future Gadfly can replace PyPlot.

## Installation

```julia
Pkg.clone("https://github.com/slundberg/SimplePlot.jl.git")
```

## Usage

```julia
using SimplePlot
```

### Bar plot

```julia
plot(
    bar(["G1", "G2", "G3", "G4"], [3,6,2,4], "A", color="#ffff00"),
    bar(["G1", "G2", "G3", "G4"], [8,3,5,1], "B", alpha=0.5, linewidth=2),
    legend="none",
    ylabel="x axis",
    ylabel="y axis",
    figsize=(5,3),
    stacked=false,
    xtickrotation="horizontal",
    xticklabels=true,
    ylim=(0,10)
)
```

### Line plot

```julia
plot(
    line(1:4, [3,6,2,4], "A", color="#ffff00"),
    line(1:4, [8,3,5,1], "B"),
    legend="none",
    ylabel="x axis",
    ylabel="y axis",
    figsize=(5,3),
    stacked=false,
    xtickrotation="horizontal",
    xticklabels=true,
    ylim=(0,10)
)
```



