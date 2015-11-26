# SimplePlot

[![Build Status](https://travis-ci.org/slundberg/SimplePlot.jl.svg?branch=master)](https://travis-ci.org/slundberg/SimplePlot.jl)

A simple collection of plotting methods designed to have a very simple and clean interface. Different plots types form layers that can be combined into a single axis.

This package was motivated by needs for publication figures. I wanted to customize the plots more than is currently possible with Gadfly, so it is currently based on PyPlot (which uses matplotlib). Hopefully at some point in the future Gadfly can replace PyPlot.

## Installation

```julia
Pkg.clone("https://github.com/slundberg/SimplePlot.jl.git")
```

## Usage

Every plot is composed of one or more layers and a single axis. Building a layer directly is simple:

```julia
using SimplePlot

line(1:10, rand(10))
```

When a layer object is displayed it will automatically get wrapped in a default axis. To customize the axis or combine multiple layers into a single axis use the `axis()` function:

```julia
axis(
    line(1:10, rand(10)),
    line(1:10, rand(10)),
    xlabel="count"
)
```



### Bar plot

```julia
bar(["G1", "G2", "G3", "G4"], [3,6,2,4])
```
or
```julia
axis(
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
axis(
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



