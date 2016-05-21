
export area

type AreaLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(l::AreaLayer, symbol) = get(l.params, symbol, get(areaDefaults, symbol, nothing))
defaults(l::AreaLayer) = areaDefaults
supportslegend(l::AreaLayer) = true
areaDefaults = Dict(
    :x => nothing,
    :y1 => nothing,
    :y2 => nothing,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0
)


"Build a AreaLayer"
function area(; kwargs...)
    kwargs = Dict(kwargs)
    if haskey(kwargs, :x) && haskey(kwargs, :y1) && haskey(kwargs, :y2)
        @assert length(kwargs[:x]) == length(kwargs[:y1]) "x and y1 arguments must be the same length"
        @assert length(kwargs[:x]) == length(kwargs[:y2]) "x and y2 arguments must be the same length"
    end

    AreaLayer(get_params(areaDefaults, kwargs)...)
end
area(y; kwargs...) = area(x=1:length(y), y1=zeros(length(y)), y2=y; kwargs...)
area(y, label::AbstractString; kwargs...) = area(x=1:length(y), y1=zeros(length(y)), y2=y, label=label; kwargs...)
area(x, y; kwargs...) = area(x=x, y1=zeros(length(y)), y2=y; kwargs...)
area(x, y, label::AbstractString; kwargs...) = area(x=x, y1=zeros(length(y)), y2=y, label=label; kwargs...)
area(x, y1, y2; kwargs...) = area(x=x, y1=y1, y2=y2; kwargs...)
area(x, y1, y2, label::AbstractString; kwargs...) = area(x=x, y1=y1, y2=y2, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::AreaLayer)
    @assert param(l, :x) != nothing "line layer must have an x parameter"
    @assert param(l, :y1) != nothing "line layer must have an y1 parameter"
    @assert param(l, :y2) != nothing "line layer must have an y2 parameter"
    ax[:fill_between](
        param(l, :x),
        param(l, :y1),
        param(l, :y2),
        facecolor = param(l, :color),
        linewidth = 0,
        alpha = param(l, :alpha),
        label = param(l, :label)
    )
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::AreaLayer) = Base.show(io, axis(x))

pyplot(x::AreaLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::AreaLayer) = save(outPath, axis(x))
