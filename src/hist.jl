
export histplot

type HistLayer <: Layer
    x::AbstractVector
    label
    color
    alpha::Float64
    bins
    range
    edgecolor
end

"Build a HistLayer"
function histplot(; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"

    HistLayer(
        kwargs[:x],
        get(kwargs, :label, nothing),
        get(kwargs, :color, nothing),
        get(kwargs, :alpha, 1.0),
        get(kwargs, :bins, 10),
        get(kwargs, :range, nothing),
        get(kwargs, :edgecolor, "#ffffff")
    )
end
histplot(x; kwargs...) = histplot(x=x; kwargs...)
histplot(x, label::ASCIIString; kwargs...) = histplot(x=x, label=label; kwargs...)
histplot(x, bins, label::ASCIIString; kwargs...) = histplot(x=x, bins=bins, label=label; kwargs...)
histplot(x, bins; kwargs...) = histplot(x=x, bins=bins; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::HistLayer)
    n,bins,p = ax[:hist](l.x, bins=l.bins, facecolor=l.color, alpha=l.alpha, range=l.range, edgecolor=l.edgecolor)
    p
end

"This wraps the layer in an axis for direct display"
Base.show(io::Base.IO, h::HistLayer) = Base.display(axis(h))
