
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
    :vlinewidth => nothing,
    :linestyle => "-",
    :marker => nothing,
    :markerarea => 6,
    :markerfacecolor => nothing,
    :markeredgecolor => "none"
)


"Build a LineLayer"
function line(; kwargs...)
    kwargs = Dict(kwargs)
    if haskey(kwargs, :x) && haskey(kwargs, :y)
        @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"
    end

    LineLayer(get_params(lineDefaults, kwargs)...)
end
line(y; kwargs...) = line(x=1:length(y), y=y; kwargs...)
line(y, label::AbstractString; kwargs...) = line(x=1:length(y), y=y, label=label; kwargs...)
line(x, y; kwargs...) = line(x=x, y=y; kwargs...)
line(x, y, label::AbstractString; kwargs...) = line(x=x, y=y, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::LineLayer)
    @assert param(l, :x) != nothing "line layer must have an x parameter"
    @assert param(l, :y) != nothing "line layer must have an y parameter"
    p = nothing
    if param(l, :vlinewidth) != nothing
        len = length(param(l, :vlinewidth))
        @assert (len == length(param(l, :y))) || len == 1 "vlinewidth must be a scalar or the same length as y"
        p = ax[:fill_between](
            param(l, :x),
            param(l, :y) .- param(l, :vlinewidth)/2,
            param(l, :y) .+ param(l, :vlinewidth)/2,
            facecolor = param(l, :color),
            linewidth = 0,
            alpha = param(l, :alpha),
            label = param(l, :label)
        )
    else
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
        )[1] # oddity of matplotlib requires the dereference
    end
    p
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::LineLayer) = Base.show(io, axis(x))

pyplot(x::LineLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::LineLayer) = save(outPath, axis(x))
