
function bar(;kwargs...)
    kwargs = Dict(kwargs)
    fig,ax = subplots(figsize=get(kwargs, :figsize, (5, 3)))
    stacked = get(kwargs, :stacked, false)

    x,y,color = set_defaults(ax; kwargs...)

    colors = get(kwargs, :colors, defaultColors)
    xvalues = unique(x)
    xcount = Int64[sum(x .== v) for v in xvalues]
    cvalues = unique(color)
    ind = 1:length(xvalues)
    maxBarOverlap = stacked ? 1 : maximum(xcount)
    width = 1/maxBarOverlap * 0.8
    groupSpacing = 0.2

    # find which colors are present at each x value
    cgroups = Any[]
    for i in 1:length(xvalues)
        push!(cgroups, color[find(x .== xvalues[i])])
    end

    bars = Any[]
    lastVals = zeros(length(xvalues))
    for (i,c) in (stacked ? reverse(collect(enumerate(cvalues))) : enumerate(cvalues))
        vals = Float64[]
        pos = Float64[]
        inds = Int64[]
        for j in 1:length(xvalues)
            cind = stacked ? 1 : findfirst(cgroups[j] .== c)
            if cind != 0
                push!(pos, j-1 + (cind-1)*width + width*0.1 + groupSpacing)
                push!(vals, y[findfirst((color .== c) .* (x .== xvalues[j]))])
                push!(inds, j)
            end
        end
        push!(bars, ax[:bar](pos, vals, width*0.8, color=colors[i], bottom=lastVals[inds], edgecolor="none"))
        if stacked
            lastVals[:] = 0
            lastVals[inds] = vals
        end
    end
    ax[:set_xlim](0,length(xvalues)+groupSpacing)
    ax[:set_xticks](ind - 1 .+ width*maxBarOverlap/2 + groupSpacing)
    ax[:set_xticklabels](get(kwargs, :xticklabels, true) ? xvalues : Any[])
    ax[:set_xticklabels](
        get(kwargs, :xticklabels, true) ? xvalues : Any[],
        rotation=get(kwargs, :xtickrotation, "horizontal")
    )
    
    loc = get(kwargs, :legend, "upper right")
    loc != "none" && ax[:legend](stacked ? reverse(bars) : bars, cvalues, frameon=false, loc=loc)
    fig
end
