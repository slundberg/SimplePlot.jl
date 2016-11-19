
export matplot

type MatLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(l::MatLayer, symbol) = get(l.params, symbol, get(matDefaults, symbol, nothing))
defaults(l::MatLayer) = matDefaults
supportslegend(l::MatLayer) = false
matDefaults = Dict(
    :x => nothing,
    :y => nothing,
    :matrix => nothing
)

"Convert positions to box boundaries for grid"
function convert_to_bounds(vals)
    bounds = zeros(length(vals)+1)
    bounds[1] =  vals[1] - (vals[2] - vals[1])/2
    for i in 2:length(vals)
        bounds[i] = vals[i] - (vals[i] - vals[i-1])/2
    end
    bounds[end] = vals[end] + (vals[end] - vals[end-1])/2
    bounds
end

"Build a MatLayer"
function matplot(; kwargs...)
    kwargs = Dict{Any,Any}(kwargs)

    @assert haskey(kwargs, :matrix) "matrix argument must be provided"
    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == size(kwargs[:matrix])[2] "x length does not match # of matrix columns"
    @assert length(kwargs[:y]) == size(kwargs[:matrix])[1] "y length does not match # of matrix rows"

    MatLayer(get_params(matDefaults, kwargs)...)
end
matplot(matrix; kwargs...) = matplot(x=1:size(matrix)[2], y=1:size(matrix)[1], matrix=matrix; kwargs...)

"Draw onto an axis"
function draw(ax, state, l::MatLayer)
    xb = repmat(convert_to_bounds(param(l, :x)), 1, length(param(l, :y))+1)'
    yb = repmat(convert_to_bounds(param(l, :y)), 1, length(param(l, :x))+1)

    ax[:pcolormesh](
        xb, yb, param(l, :matrix)
    )
end

"This wraps the layer for direct display"
function Base.show(io::Base.IO, x::MatLayer)
    if all(param(x, :y) .== 1:size(param(x, :matrix))[1])
        xb = convert_to_bounds(param(x, :x))
        yb = convert_to_bounds(param(x, :y))
        xlim = (minimum(xb),maximum(xb))
        ylim = (minimum(yb),maximum(yb))
        ratio = (xlim[2]-xlim[1])/(ylim[2]-ylim[1])
        figsize = ratio >= 1 ? (5,5/ratio) : (5*ratio,5)

        Base.show(io, axis(
            x,
            inverty=true,
            xlim=xlim,
            ylim=ylim,
            spineleft=false,
            spinebottom=false,
            xtickspos="none",
            ytickspos="none",
            xticklabelpos="top",
            figsize=figsize
        ))
    else
        Base.show(io, axis(x))
    end
end

pyplot(x::MatLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::MatLayer) = save(outPath, axis(x))
