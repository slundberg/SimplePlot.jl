
export bar

type BarLayer <: Layer
    x::AbstractVector
    y::AbstractVector
    label
    color
    alpha::Float64
end

"Build a BarLayer"
function bar(; kwargs...)
    kwargs = Dict(kwargs)

    @assert haskey(kwargs, :x) "x argument must be provided"
    @assert haskey(kwargs, :y) "y argument must be provided"
    @assert length(kwargs[:x]) == length(kwargs[:y]) "x and y arguments must be the same length"

    BarLayer(
        kwargs[:x],
        kwargs[:y],
        get(kwargs, :label, nothing),
        get(kwargs, :color, nothing),
        get(kwargs, :alpha, 1.0)
    )
end
bar(x, y; kwargs...) = bar(x=x, y=y; kwargs...)
bar(x, y, label; kwargs...) = bar(x=x, y=y, label=label; kwargs...)

"Process all layers on an axis to determine the bar layout settings."
function bar_axis_parser(ax, state, layers...; kwargs...)
    kwargs = Dict(kwargs)

    stacked = get(kwargs, :stacked, false)

    # check for how many bar layers are present
    barLayers = collect(filter(l->typeof(l)==BarLayer, layers))
    if length(barLayers) == 0 return end
    allBar = length(barLayers) == length(layers)

    x = vcat([l.x for l in barLayers]...)
    y = vcat([l.y for l in barLayers]...)
    labels = vcat([[l.label for x in l.x] for l in barLayers]...)
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

    ax[:set_xlim](0,length(xvalues)+groupSpacing)
    ax[:set_xticks](ind - 1 .+ width*maxBarOverlap/2 + groupSpacing)
    ax[:xaxis][:set_ticks_position]("none")
    ax[:set_xticklabels](get(kwargs, :xticklabels, true) ? xvalues : Any[])
    ax[:set_xticklabels](
        get(kwargs, :xticklabels, true) ? xvalues : Any[],
        rotation=get(kwargs, :xtickrotation, "horizontal")
    )

    state[:bar_states] = Any[]
    lastVals = zeros(length(xvalues))
    for l in (stacked ? reverse(barLayers) : barLayers)
        vals = Float64[]
        pos = Float64[]
        inds = Int64[]
        widths = Float64[]
        for j in 1:length(xvalues)
            cind = findfirst(cgroups[j] .== l.label)
            if cind != 0
                if stacked cind = 1 end
                localWidth = (stacked ? 1 : 1/length(cgroups[j])) * 0.8
                push!(pos, j-1 + (cind-1)*localWidth + localWidth*0.1 + groupSpacing)
                push!(vals, y[findfirst((labels .== l.label) .* (x .== xvalues[j]))])
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
    state[:bar_ind] = 1 # used for counting which bar state to use when drawing
end
register_axis_parser(bar_axis_parser);

"Draw onto an axis"
function draw(ax, state, l::BarLayer)
    i = state[:bar_ind]
    s = state[:bar_states][i]
    p = ax[:bar](s[1], s[2], s[3], color=l.color, bottom=s[4], edgecolor="none")
    state[:bar_ind] += 1
    p
end

"This wraps the layer in an axis for direct display"
Base.show(io::Base.IO, h::BarLayer) = Base.display(axis(h))
