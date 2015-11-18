module SimplePlot

defaultColors = ["#3366CC", "#DC3912", "#FF9902", "#0C9618"]

function set_axis_defaults(ax; kwargs...)
    kwargs = Dict(kwargs)
    ax[:spines]["right"][:set_visible](false)
    ax[:spines]["top"][:set_visible](false)
    ax[:yaxis][:set_ticks_position]("left")
    ax[:xaxis][:set_ticks_position]("none")
    haskey(kwargs, :xlabel) && ax[:set_xlabel](kwargs[:xlabel])
    haskey(kwargs, :ylabel) && ax[:set_ylabel](kwargs[:ylabel])
    haskey(kwargs, :xlim) && ax[:set_xlim](kwargs[:xlim])
    haskey(kwargs, :ylim) && ax[:set_ylim](kwargs[:ylim])
end

include("bar.jl")
include("line.jl")

end # module
