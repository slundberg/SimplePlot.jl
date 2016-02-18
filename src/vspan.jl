
export vspan

type VSpanLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(vspan::VSpanLayer, symbol) = get(vspan.params, symbol, get(vspanDefaults, symbol, nothing))
defaults(vspan::VSpanLayer) = vspanDefaults
supportslegend(l::VLineLayer) = false
vspanDefaults = Dict(
    :xmin => 0,
    :xmax => 1,
    :ymin => 0,
    :ymax => 1,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0,
    :linewidth => 1,
    :linestyle => nothing
)


"Build a VSpanLayer"
function vspan(; kwargs...)
    kwargs = Dict(kwargs)
    VSpanLayer(get_params(vspanDefaults, kwargs)...)
end
vspan(xmin, xmax; kwargs...) = vspan(xmin=xmin, xmax=xmax; kwargs...)
vspan(xmin, xmax, label::AbstractString; kwargs...) = vspan(xmin=xmin, xmax=xmax, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::VSpanLayer)
    args = Dict()

    p = ax[:axvspan](
        xmin = param(l, :xmin),
        xmax = param(l, :xmax),
        ymin = param(l, :ymin),
        ymax = param(l, :ymax),
        color = param(l, :color),
        linewidth = param(l, :linewidth),
        linestyle = param(l, :linestyle),
        alpha = param(l, :alpha)
    )
    p#[1] # oddity of matplotlib requires the dereference
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::VSpanLayer) = Base.show(io, axis(x))

pyplot(x::VSpanLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::VSpanLayer) = save(outPath, axis(x))
