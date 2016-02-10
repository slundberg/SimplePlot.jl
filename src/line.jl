
export line

type LineLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(l::LineLayer, symbol) = get(l.params, symbol, get(lineDefaults, symbol, nothing))
defaults(l::LineLayer) = lineDefaults
supportslegend(l::LineLayer) = true
lineDefaults = Dict(
    :x => nothing,
    :y => nothing,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0,
    :linewidth => 1,
    :linestyle => "-",
    :marker => nothing,
    :markerarea => 6,
    :markerfacecolor => nothing,
    :markeredgecolor => "none"
)


"Build a LineLayer"
function line(; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"

    LineLayer(get_params(lineDefaults, kwargs)...)
end
line(y; kwargs...) = line(x=1:length(y), y=y; kwargs...)
line(y, label::AbstractString; kwargs...) = line(x=1:length(y), y=y, label=label; kwargs...)
line(x, y; kwargs...) = line(x=x, y=y; kwargs...)
line(x, y, label::AbstractString; kwargs...) = line(x=x, y=y, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::LineLayer)
    p = ax[:plot](
        param(l, :x),
        param(l, :y),
        color = param(l, :color),
        linewidth = param(l, :linewidth),
        linestyle = param(l, :linestyle),
        alpha = param(l, :alpha),
        marker = param(l, :marker),
        markersize = param(l, :markerarea) * mark_rescaling(param(l, :marker)),
        markerfacecolor = param(l, :markerfacecolor),
        markeredgecolor = param(l, :markeredgecolor),
        label = param(l, :label)
    )
    p[1] # oddity of matplotlib requires the dereference
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::LineLayer) = Base.show(io, axis(x))

pyplot(x::LineLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::LineLayer) = save(outPath, axis(x))
