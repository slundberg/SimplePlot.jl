
export violin

type ViolinLayer <: Layer
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(l::ViolinLayer, symbol) = get(l.params, symbol, get(violinDefaults, symbol, nothing))
defaults(l::ViolinLayer) = violinDefaults
supportslegend(l::ViolinLayer) = false
violinDefaults = Dict(
    :x => nothing,
    :y => nothing,
    :label => nothing,
    :color => nothing,
    :data => nothing,
    :alpha => 1.0
)

"Build a ViolinLayer"
function violin(; kwargs...)
    kwargs = Dict{Any,Any}(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :data) "data argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:data]) "x and data arguments must be the same length"

    ViolinLayer(get_params(violinDefaults, kwargs)...)
end
violin(x, data; kwargs...) = violin(x=x, data=data; kwargs...)
violin(x, data, label; kwargs...) = violin(x=x, data=data, label=label; kwargs...)

"Process all layers on an axis to determine the violin layout settings."
function violin_axis_parser(ax, state, axis)

    # check for how many violin layers are present
    violinLayers = collect(filter(l->typeof(l)==ViolinLayer, param(axis, :layers)))
    if length(violinLayers) == 0 return end
    allBar = length(violinLayers) == length(param(axis, :layers))

    x = vcat([param(l, :x) for l in violinLayers]...)
    data = vcat([param(l, :data) for l in violinLayers]...)
    labels = vcat([[param(l, :label) for x in param(l, :x)] for l in violinLayers]...)
    xvalues = unique(x)
    xcount = Int64[sum(x .== v) for v in xvalues]
    ind = 1:length(xvalues)
    maxXOverlap = maximum(xcount)
    width = 1/maxXOverlap * 0.8
    groupSpacing = 0.2

    # find which colors are present at each x value
    cgroups = Any[]
    for i in ind
        push!(cgroups, labels[find(x .== xvalues[i])])
    end

    ax[:set_xlim](0,length(xvalues)+groupSpacing)
    ax[:set_xticks](ind - 1 .+ width*maxXOverlap/2 + groupSpacing)
    ax[:xaxis][:set_ticks_position]("none")
    ax[:set_xticklabels](
        param(axis, :xticklabels) != nothing ? param(axis, :xticklabels) : xvalues,
        rotation=param(axis, :xtickrotation)
    )

    state[:violin_states] = Any[]
    for l in violinLayers
        vals = Any[]
        pos = Float64[]
        inds = Int64[]
        widths = Float64[]
        for j in 1:length(xvalues)
            cind = findfirst(cgroups[j] .== param(l, :label))
            if cind != 0
                localWidth = (1/length(cgroups[j])) * 0.8
                push!(pos, j-1 + (cind-1)*localWidth  + groupSpacing + localWidth/2)
                push!(vals, data[findfirst((labels .== param(l, :label)) .* (x .== xvalues[j]))])
                push!(inds, j)
                push!(widths, localWidth)
            end
        end

        push!(state[:violin_states], (pos, vals, widths*0.8))
    end

    reverse!(state[:violin_states])
    state[:violin_ind] = 1 # used for counting which bar state to use when drawing
end
register_axis_parser(violin_axis_parser)

"Draw onto an axis"
function draw(ax, state, l::ViolinLayer)
    i = state[:violin_ind]
    s = state[:violin_states][i]
    p = ax[:violinplot](s[2], positions=s[1], widths=s[3], showextrema=false)
    for pc in p["bodies"]
        pc[:set_facecolor](param(l, :color))
        pc[:set_edgecolor]("none")
        pc[:set_alpha](param(l, :alpha))
    end
    state[:violin_ind] += 1
    p
end

"This wraps the layer in an axis for direct display"
Base.show(io::Base.IO, h::ViolinLayer) = Base.display(axis(h))
