
export hbar

type HBarLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(x::HBarLayer, symbol) = get(x.params, symbol, get(hbarDefaults, symbol, nothing))
defaults(bar::HBarLayer) = hbarDefaults
supportslegend(l::HBarLayer) = false
hbarDefaults = Dict(
    :x => nothing,
    :y => nothing,
    :label => nothing,
    :color => nothing,
    :alpha => 1.0
)

"Build a HBarLayer"
function hbar(; kwargs...)
    kwargs = Dict{Any,Any}(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"

    HBarLayer(get_params(hbarDefaults, kwargs)...)
end
hbar(y; kwargs...) = hbar(x=1:length(y), y=y, xticklabels=Any[]; kwargs...)
hbar(x, y; kwargs...) = hbar(x=x, y=y; kwargs...)
hbar(x, y, label; kwargs...) = hbar(x=x, y=y, label=label; kwargs...)

"Process all layers on an axis to determine the bar layout settings."
function hbar_axis_parser(ax, state, axis) #layers...; kwargs...)
    stacked = param(axis, :stacked)

    # check for how many bar layers are present
    barLayers = collect(filter(l->typeof(l)==HBarLayer, param(axis, :layers)))
    if length(barLayers) == 0 return end
    allBar = length(barLayers) == length(param(axis, :layers))

    x = vcat([param(l, :x) for l in barLayers]...)
    y = vcat([param(l, :y) for l in barLayers]...)
    labels = vcat([[param(l, :label) for x in param(l, :x)] for l in barLayers]...)
    xvalues = unique(x)
    xcount = Int64[sum(x .== v) for v in xvalues]
    ind = 1:length(xvalues)
    maxBarOverlap = stacked ? 1 : maximum(xcount)
    width = 1/maxBarOverlap * 0.8
    groupSpacing = 0.2

    # find which colors are present at each x value
    cgroups = Any[]
    for i in ind
        push!(cgroups, labels[find(x .== xvalues[i])])
    end

    ax[:set_ylim](0,length(xvalues)+groupSpacing)
    ax[:set_yticks](ind - 1 .+ width*maxBarOverlap/2 + groupSpacing)
    ax[:yaxis][:set_ticks_position]("none")
    ax[:set_yticklabels](
        param(axis, :yticklabels) != nothing ? param(axis, :yticklabels) : xvalues,
        rotation=param(axis, :ytickrotation)
    )

    state[:bar_states] = Any[]
    lastVals = zeros(length(xvalues))
    for l in (stacked ? reverse(barLayers) : barLayers)
        vals = Float64[]
        pos = Float64[]
        inds = Int64[]
        widths = Float64[]
        for j in 1:length(xvalues)
            cind = findfirst(cgroups[j] .== param(l, :label))
            if cind != 0
                if stacked cind = 1 end
                localWidth = (stacked ? 1 : 1/length(cgroups[j])) * 0.8
                push!(pos, j-1 + (cind-1)*localWidth + localWidth*0.1 + groupSpacing)
                push!(vals, y[findfirst((labels .== param(l, :label)) .* (x .== xvalues[j]))])
                push!(inds, j)
                push!(widths, localWidth)
            end
        end

        push!(state[:bar_states], (pos, vals, widths*0.8, deepcopy(lastVals[inds])))
        if stacked
            #lastVals[:] = 0
            lastVals[inds] += vals
        end
    end

    !stacked && reverse!(state[:bar_states])
    state[:hbar_ind] = 1 # used for counting which bar state to use when drawing

    # top to bottom instead of bottom to top
    ax[:invert_yaxis]()
end
register_axis_parser(hbar_axis_parser);

"Draw onto an axis"
function draw(ax, state, l::HBarLayer)
    i = state[:hbar_ind]
    s = state[:bar_states][i]
    p = ax[:barh](s[1], s[2], s[3], color=param(l, :color), left=s[4], edgecolor="none")
    state[:hbar_ind] += 1
    p
end

"This wraps the layer in an axis for direct display"
Base.show(io::Base.IO, x::HBarLayer) = Base.show(io, axis(x))

pyplot(x::HBarLayer) = pyplot(axis(x))
save(outPath::AbstractString, x::HBarLayer) = save(outPath, axis(x))
