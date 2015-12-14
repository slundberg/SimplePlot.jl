
export hline

type HLineLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(hline::HLineLayer, symbol) = get(hline.params, symbol, get(hlineDefaults, symbol, nothing))
defaults(hline::HLineLayer) = hlineDefaults
hlineDefaults = Dict(
    :xmin => 0,
    :xmax => 1,
    :y => 0,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0,
    :linewidth => 1,
    :linestyle => "-"
)


"Build a HLineLayer"
function hline(; kwargs...)
    kwargs = Dict(kwargs)
    HLineLayer(get_params(hlineDefaults, kwargs)...)
end
hline(y; kwargs...) = hline(y=y; kwargs...)
hline(y, label::AbstractString; kwargs...) = hline(y=y, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::HLineLayer)
    args = Dict()

    p = ax[:axhline](
        y = param(l, :y),
        xmin = param(l, :xmin),
        xmax = param(l, :xmax),
        color = param(l, :color),
        linewidth = param(l, :linewidth),
        linestyle = param(l, :linestyle),
        alpha = param(l, :alpha)
    )
    p#[1] # oddity of matplotlib requires the dereference
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::HLineLayer) = Base.show(io, axis(x))

pyplot(x::HLineLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::HLineLayer) = save(outPath, axis(x))
