
export point

"Just builds a LineLayer with different defaults"
function point(; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"

    LineLayer(
        vec(kwargs[:x]),
        vec(kwargs[:y]),
        get(kwargs, :label, nothing),
        get(kwargs, :color, nothing),
        get(kwargs, :alpha, 1.0),
        get(kwargs, :linewidth, 3),
        get(kwargs, :linestyle, "none"),
        get(kwargs, :marker, "."),
        get(kwargs, :markersize, nothing),
        get(kwargs, :markerfacecolor, nothing)
    )
end
point(x, y; kwargs...) = point(x=x, y=y; kwargs...)
point(x, y, label; kwargs...) = point(x=x, y=y, label=label; kwargs...)
