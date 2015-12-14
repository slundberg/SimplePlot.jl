
export point

"Just builds a LineLayer with different defaults"
function point(; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"

    pointDefaults = merge(lineDefaults, Dict(
        "linestyle" => "none",
        "marker" => ".",
    ))

    LineLayer(get_params(pointDefaults, kwargs)...)
end
point(y; kwargs...) = point(x=1:length(y), y=y; kwargs...)
point(y, label::AbstractString; kwargs...) = point(x=1:length(y), y=y, label=label; kwargs...)
point(x, y; kwargs...) = point(x=x, y=y; kwargs...)
point(x, y, label::AbstractString; kwargs...) = point(x=x, y=y, label=label; kwargs...)
