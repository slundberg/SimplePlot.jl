module SimplePlot

using PyPlot

# this allows us to decide when a plot gets shown
ioff()

# we default to svg because that is how they will go into a paper
PyPlot.svg(true)

defaultColors = ["#3366CC", "#DC3912", "#FF9902", "#0C9618"]

function set_defaults(ax; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"
    color = get(kwargs, :color, ones(length(kwargs[:x])))
    @assert length(kwargs[:x]) == length(color) "x and color arguments must be the same length"

    ax[:spines]["right"][:set_visible](false)
    ax[:spines]["top"][:set_visible](false)
    ax[:yaxis][:set_ticks_position]("left")
    ax[:xaxis][:set_ticks_position]("none")
    haskey(kwargs, :xlabel) && ax[:set_xlabel](kwargs[:xlabel])
    haskey(kwargs, :ylabel) && ax[:set_ylabel](kwargs[:ylabel])
    haskey(kwargs, :xlim) && ax[:set_xlim](kwargs[:xlim])
    haskey(kwargs, :ylim) && ax[:set_ylim](kwargs[:ylim])

    kwargs[:x], kwargs[:y], color
end

include("bar.jl")
include("line.jl")

end # module
