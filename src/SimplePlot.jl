module SimplePlot

import FileIO.save
import PyPlot
using PyCall
@pyimport matplotlib.patches as mpatches

export save

# this allows us to decide when a plot gets shown
PyPlot.ioff()

# we default to svg because that is how they will go into a paper
PyPlot.svg(false)

# these are based on a good set of colors used in Google sheets
colors = [
    "#3366CC", "#DC3912", "#FF9902", "#0C9618", "#0099C6",
    "#990099", "#DD4477", "#66AA00", "#B82E2E", "#316395",
    "#994499", "#22AA99", "#AAAA11", "#6633CC", "#E67300"
]

abstract Layer

function save(outPath::AbstractString, plot::PyPlot.Figure)
    if endswith(outPath, ".pdf")
        open(f->writemime(f, "application/pdf", plot), outPath, "w")
    elseif endswith(outPath, ".png")
        open(f->writemime(f, "image/png", plot), outPath, "w")
    else
        error("Unrecognized file type extension! ($outPath)")
    end
end

function print_params(obj)
    println()
    println()
    println("Params for ", typeof(obj))
    dump(obj.params)
    println()
    println("Unused params for ", typeof(obj))
    dump(obj.unusedParams)
end

function get_params(defaults, kwargs)
    usedParams = Dict()
    unusedParams = Dict()
    for k in keys(kwargs)
        if haskey(defaults, k)
            usedParams[k] = kwargs[k]
        else
            unusedParams[k] = kwargs[k]
        end
    end
    usedParams,unusedParams
end

"Fixes the inconsistent areas of matplotlib's markers"
function mark_rescaling(mark)
    if mark == "."
        return 2.8
    elseif mark == "h"
        return 1.1
    elseif mark == "D"
        return 0.8
    elseif mark == "s"
        return 0.9
    else
        return 1.0
    end
end

include("axis.jl")
include("grid.jl")
include("plot.jl")

# include all the specific plot types
include("bar.jl")
include("hbar.jl")
include("line.jl")
include("mat.jl")
include("scatter.jl")
include("violin.jl")
include("hist.jl")
include("hline.jl")
include("vline.jl")
include("vspan.jl")

end # module
