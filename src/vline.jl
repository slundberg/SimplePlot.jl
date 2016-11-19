
export vline

type VLineLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(vline::VLineLayer, symbol) = get(vline.params, symbol, get(vlineDefaults, symbol, nothing))
defaults(vline::VLineLayer) = vlineDefaults
supportslegend(l::VLineLayer) = false
vlineDefaults = Dict(
    :ymin => 0,
    :ymax => 1,
    :x => 0,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0,
    :linewidth => 1,
    :linestyle => "-"
)


"Build a VLineLayer"
function vline(; kwargs...)
    kwargs = Dict{Any,Any}(kwargs)
    VLineLayer(get_params(vlineDefaults, kwargs)...)
end
vline(x; kwargs...) = vline(x=x; kwargs...)
vline(x, label::AbstractString; kwargs...) = vline(x=x, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::VLineLayer)
    args = Dict()

    p = ax[:axvline](
        x = param(l, :x),
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
Base.show(io::Base.IO, x::VLineLayer) = Base.show(io, axis(x))

pyplot(x::VLineLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::VLineLayer) = save(outPath, axis(x))
