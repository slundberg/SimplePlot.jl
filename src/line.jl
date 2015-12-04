
export line

type LineLayer <: Layer
    x::AbstractVector
    y::AbstractVector
    label
    color
    alpha::Float64
    linewidth::Float64
    linestyle
    marker
    markersize
    markerfacecolor
end

"Build a LineLayer"
function line(; kwargs...)
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
        get(kwargs, :linewidth, 1),
        get(kwargs, :linestyle, "-"),
        get(kwargs, :marker, nothing),
        get(kwargs, :markersize, 6),
        get(kwargs, :markerfacecolor, nothing)
    )
end
line(y; kwargs...) = line(x=1:length(y), y=y; kwargs...)
line(y, label::AbstractString; kwargs...) = line(x=1:length(y), y=y, label=label; kwargs...)
line(x, y; kwargs...) = line(x=x, y=y; kwargs...)
line(x, y, label::AbstractString; kwargs...) = line(x=x, y=y, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::LineLayer)
    args = Dict()

    p = ax[:plot](
        l.x,
        l.y,
        color=l.color,
        linewidth=l.linewidth,
        linestyle=l.linestyle,
        alpha=l.alpha,
        marker=l.marker,
        markersize=l.markersize,
        markerfacecolor=l.markerfacecolor
    )
    p[1] # oddity of matplotlib requires the dereference
end

"This wraps the layer in an axis for direct display"
Base.show(io::Base.IO, h::LineLayer) = Base.display(axis(h))
