
export histplot

type HistLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

function param(l::HistLayer, symbol)
    if haskey(l.params, symbol) return l.params[symbol] end

    # if we are in step change the default edge color to something visible
    if symbol == :edgecolor && get(l.params, :histtype, "") == "step"
        return param(l, :color)
    end

    get(histDefaults, symbol, nothing)
end
defaults(l::HistLayer) = histDefaults
supportslegend(l::HistLayer) = false
histDefaults = Dict(
    :x => nothing,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0,
    :bins => 10,
    :range => nothing,
    :edgecolor => "#ffffff",
    :histtype => "bar",
    :linewidth => 1,
    :linestyle => "solid",
    :weights => nothing,
    :bottom => nothing
)

"Build a HistLayer"
function histplot(; kwargs...)
    kwargs = Dict{Any,Any}(kwargs)
    @assert haskey(kwargs, :x) "x argument must be provided"
    HistLayer(get_params(histDefaults, kwargs)...)
end
histplot(x; kwargs...) = histplot(x=x; kwargs...)
histplot(x, label::String; kwargs...) = histplot(x=x, label=label; kwargs...)
histplot(x, bins, label::String; kwargs...) = histplot(x=x, bins=bins, label=label; kwargs...)
histplot(x, bins; kwargs...) = histplot(x=x, bins=bins; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::HistLayer)
    n,bins,p = ax[:hist](
        param(l, :x),
        bins = param(l, :bins),
        facecolor = param(l, :color),
        alpha = param(l, :alpha),
        range = param(l, :range),
        edgecolor = param(l, :edgecolor),
        histtype = param(l, :histtype),
        linewidth = param(l, :linewidth),
        linestyle = param(l, :linestyle),
        weights = param(l, :weights),
        bottom = param(l, :bottom)
    )
    p
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::HistLayer) = Base.show(io, axis(x))

pyplot(x::HistLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::HistLayer) = save(outPath, axis(x))
