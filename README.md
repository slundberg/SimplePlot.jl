# SimplePlot

[![Build Status](https://travis-ci.org/slundberg/SimplePlot.jl.svg?branch=master)](https://travis-ci.org/slundberg/SimplePlot.jl)

A <font color="red">collection</font> of plotting methods designed to have a very simple and clean interface.



```julia
line(rand(10))
```

```julia
axis(
    bar(rand(10), label="A"),
    bar(rand(10), label="B")
)
```

```julia
scatter(rand(10), rand(10), xlabel="random")
```

## Installation

```julia
Pkg.clone("https://github.com/slundberg/SimplePlot.jl.git")
```

SimplePlot is based on PyPlot.jl, which must also be installed and working with a matplotlib version greater than 1.4.3.

## Usage

SimplePlot is based on the following nested structure of components:

**plot** > **grid** ... **grid** > **axis** > **_layer_**

Every plot has a single grid object, every grid object has one or more grid or axis objects, each axis object has one or more layers. Writing this out explictly for a line plot gives:

```julia
using SimplePlot
plot(grid(1, 1, axis(line(1:10, rand(10)))))
```

### Auto-wrapping

SimplePlot is designed to provide defaults for almost everything. This means that when we try to display a line layer it will be auto-wrapped in an axis, which will be auto-wrapped in a grid, which will be auto-wrapped in a plot. This means in practice we only need to specify the layer we care about, and SimplePlot will add the rest:

```julia
line(1:10, rand(10))
```

### Parameter delegation

While auto-wrapping makes it easy to specify layers, what if we want to set an axis parameter? We could be explicit and write:

```julia
axis(line(1:10, rand(10)), xlabel="index")
```

But with parameter delagation any parameters not claimed by an object are passed to containing objects until they are claimed. This means we can set the `xlabel` parameter on the line layer and it will get automatically picked up by the auto-generated axis object during display. This makes simple plots simple, while still maintaining strict order and stucture:

```julia
line(1:10, rand(10), xlabel="index")
```

The same thing works for paremeters given to higher containers, children can claim an unused parameter from a parent object. This makes it easy to set common parameters across many layers:

```julia
axis(
    line(1:10, rand(10)),
    line(1:10, rand(10)),
    line(1:10, rand(10)),
    linewidth=2
)
```

## Documentation

Below is a set of examples that illustrate many of the options available. However, for now, taking a quick look at the source is the best way to see all the supported options. Since everything is based on matplotlib, it is also easy to add new options if the current ones don't meet a need. PR's are welcome.

### Plot

```julia
plot(
    line(1:4, [8,3,5,1], "B"),
    figsize=(5,3)
)
```

### Grid

```julia
grid(1,2,
    line(1:4, [3,6,2,4], "A"),
    line(1:4, [8,3,5,1], "B")
)
```


### Axis

```julia
axis(
    line(1:4, [3,6,2,4], "A"),
    line(1:4, [8,3,5,1], "B"),
    legend="upper right",
    ylabel="x axis",
    ylabel="y axis",
    stacked=false,
    xtickrotation="horizontal",
    xticklabels=true,
    ylim=(0,10),
    xlim=(1,4)
)
```

### Line layer

```julia
line(1:4, [3,6,2,4], "A", color="#ffff00", alpha=0.8)
```

### Bar layer

```julia
bar(["G1", "G2", "G3", "G4"], [3,6,2,4], "Label", color="#000000", alpha=0.8)
```

### Horizontal Bar layer

```julia
hbar(["G1", "G2", "G3", "G4"], [3,6,2,4])
```

### Scatter layer

```julia
scatter(1:4, [3,6,2,4], markerarea=0.8)
```

### Histogram layer

```julia
histplot(randn(1000), bins=10, histtype="bar")
```

### Matrix layer

```julia
matplot(rand(10,20))
```

### Area layer

```julia
area(1:10, rand(10), zeros(10))
```



