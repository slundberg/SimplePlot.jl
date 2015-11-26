
export line

type LineLayer <: Layer
    x::AbstractVector
    y::AbstractVector
    label
    color
    alpha::Float64
    linewidth::Float64
end

"Build a LineLayer"
function line(; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"

    LineLayer(
        kwargs[:x],
        kwargs[:y],
        get(kwargs, :label, nothing),
        get(kwargs, :color, nothing),
        get(kwargs, :alpha, 1.0),
        get(kwargs, :linewidth, 3)
    )
end
line(x, y; kwargs...) = line(x=x, y=y; kwargs...)
line(x, y, label; kwargs...) = line(x=x, y=y, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::LineLayer)
    p = ax[:plot](l.x, l.y, color=l.color, linewidth=l.linewidth, alpha=l.alpha)
    p[1] # oddity of matplotlib requires the dereference
end

"This wraps the layer in an axis for direct display"
Base.show(io::Base.IO, h::LineLayer) = Base.display(axis(h))
