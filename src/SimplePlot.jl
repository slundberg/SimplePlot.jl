module SimplePlot

import PyPlot
using PyCall
@pyimport matplotlib.patches as mpatches

export plot

# this allows us to decide when a plot gets shown
PyPlot.ioff()

# we default to svg because that is how they will go into a paper
PyPlot.svg(true)

# these are based on a good set of colors used in Google sheets
defaultColors = ["#3366CC", "#DC3912", "#FF9902", "#0C9618", "#0099C6", "#990099"]

abstract Layer

function plot(layers...; kwargs...)
    kwargs = Dict(kwargs)

    fig,ax = build_axis(; kwargs...)

    # fill in any missing colors with the defaults
    colorPos = 1
    for l in layers
        if l.color == nothing
            l.color = defaultColors[colorPos]
            colorPos += 1
        end
    end

    # this gives plot type specific methods the chance to see all the data
    # before drawing each layer
    state = Dict() # a place for methods to store state for drawing
    for parser in plotParsers
        parser(ax, state, layers...; kwargs...)
    end

    # draw each layer
    plotObjects = Any[]
    for l in reverse(layers)
        unshift!(plotObjects, draw(ax, state, l))
    end

    build_legend(ax, layers, plotObjects; kwargs...)

    fig
end
function plot(x::AbstractVector, y::AbstractVector)
    plot(line(x, y))
end

plotParsers = Function[]
function register_plot_parser(f::Function)
    global plotParsers
    push!(plotParsers, f)
end

function build_axis(; kwargs...)
    kwargs = Dict(kwargs)

    fig,ax = PyPlot.subplots(figsize=get(kwargs, :figsize, (5, 4)))

    ax[:spines]["right"][:set_visible](false)
    ax[:spines]["top"][:set_visible](false)
    ax[:yaxis][:set_ticks_position]("left")
    ax[:xaxis][:set_ticks_position]("bottom")
    haskey(kwargs, :xlabel) && ax[:set_xlabel](kwargs[:xlabel])
    haskey(kwargs, :ylabel) && ax[:set_ylabel](kwargs[:ylabel])
    haskey(kwargs, :xlim) && ax[:set_xlim](kwargs[:xlim])
    haskey(kwargs, :ylim) && ax[:set_ylim](kwargs[:ylim])
    haskey(kwargs, :title) && ax[:set_title](kwargs[:title])
    haskey(kwargs, :xticks) && ax[:set_xticks](kwargs[:xticks])
    haskey(kwargs, :xticklabels) && ax[:set_xticklabels](kwargs[:xticklabels])
    haskey(kwargs, :yticks) && ax[:set_yticks](kwargs[:yticks])
    haskey(kwargs, :yticklabels) && ax[:set_yticklabels](kwargs[:yticklabels])

    fig,ax
end

function build_legend(ax, layers, plotObjects; kwargs...)
    kwargs = Dict(kwargs)

    # placeholders for legend (because plots like violin don't directly support a legend)
    patches = Any[]
    for l in layers
        if l.label != nothing
            push!(patches, mpatches.Patch(color=l.color, label=l.label))
        end
    end

    mask = Bool[l.label != nothing for l in layers]
    loc = get(kwargs, :legend, "best")
    if loc != "none"
        ax[:legend](handles=patches, frameon=false, loc=loc, handlelength=0.7, handleheight=0.7,
            handletextpad=0.5, fontsize="medium", labelspacing=0.4
        )
    end
end

include("bar.jl")
include("line.jl")
include("violin.jl")

end # module
