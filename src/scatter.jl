
export scatter

type ScatterLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(l::ScatterLayer, symbol) = get(l.params, symbol, get(scatterDefaults, symbol, nothing))
defaults(l::ScatterLayer) = scatterDefaults
supportslegend(l::ScatterLayer) = true
scatterDefaults = Dict(
    :x => nothing,
    :y => nothing,
    :markerarea => 6.0,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0,
    :marker => ".",
    #:markersize => 6,
    #:markerfacecolor => nothing,
    :edgecolor => "none"
)


"Build a ScatterLayer"
function scatter(; kwargs...)
    kwargs = Dict{Any,Any}(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"
    # if haskey(kwargs, :scale)
    #     @assert length(kwargs[:x]) == length(kwargs[:s]) "x and s arguments must be the same length"
    # end

    ScatterLayer(get_params(scatterDefaults, kwargs)...)
end
scatter(x, y; kwargs...) = scatter(x=x, y=y; kwargs...)
scatter(x, y, label::AbstractString; kwargs...) = scatter(x=x, y=y, label=label; kwargs...)
scatter(x, y, s; kwargs...) = scatter(x=x, y=y, markerarea=s; kwargs...)
scatter(x, y, s, label::AbstractString; kwargs...) = scatter(x=x, y=y, markerarea=s, label=label; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::ScatterLayer)
    args = Dict()

    p = ax[:scatter](
        param(l, :x),
        param(l, :y),
        s = param(l, :markerarea) .* mark_rescaling(param(l, :marker)),
        color = param(l, :color),
        alpha = param(l, :alpha),
        marker = param(l, :marker),
        edgecolor = param(l, :edgecolor),
        label = param(l, :label)
    )
    p#[1] # oddity of matplotlib requires the dereference
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::ScatterLayer) = Base.show(io, axis(x))

pyplot(x::ScatterLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::ScatterLayer) = save(outPath, axis(x))
