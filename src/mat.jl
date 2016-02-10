
export matplot

type MatLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(l::MatLayer, symbol) = get(l.params, symbol, get(matDefaults, symbol, nothing))
defaults(l::MatLayer) = matDefaults
supportslegend(l::MatLayer) = false
matDefaults = Dict(
    :matrix => nothing
)

"Build a MatLayer"
function matplot(; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :matrix) "matrix argument must be provided"

    MatLayer(get_params(matDefaults, kwargs)...)
end
matplot(matrix; kwargs...) = matplot(matrix=matrix; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::MatLayer)
    ax[:pcolormesh](
        param(l, :matrix)
    )
end

"This wraps the layer for direct display"
Base.show(io::Base.IO, x::MatLayer) = Base.show(io, axis(x))

pyplot(x::MatLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::MatLayer) = save(outPath, axis(x))
