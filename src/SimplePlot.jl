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
defaultColors = ["#3366CC", "#DC3912", "#FF9902", "#0C9618", "#0099C6", "#990099", "#DD4477", "#66AA00", "#B82E2E"]

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

include("axis.jl")
include("grid.jl")
include("plot.jl")

# include all the specific plot types
include("bar.jl")
include("line.jl")
include("point.jl")
include("violin.jl")
include("hist.jl")

end # module
