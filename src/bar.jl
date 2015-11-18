using PyPlot

function bar(;kwargs...)
    kwargs = Dict(kwargs)
    fig,ax = subplots(figsize=get(kwargs, :figsize, (6, 4)))
    set_axis_defaults(ax; kwargs...)

    x = kwargs[:x]
    y = kwargs[:y]
    color = kwargs[:color]
    colors = get(kwargs, :colors, defaultColors)
    xvalues = unique(x)
    xcount = Int64[sum(x .== v) for v in xvalues]
    cvalues = unique(color)
    ind = 1:length(xvalues)
    width = 1/length(cvalues) * 0.8
    groupSpacing = 0.2

    bars = Any[]
    for (i,c) in enumerate(cvalues)
        vals = zeros(length(xvalues))
        for j in 1:length(x)
            if color[j] == c
                vals[findfirst(xvalues, x[j])] = y[j]
            end
        end
        pos = ind .+ (i-1)*width + groupSpacing
        push!(bars, ax[:bar](pos, vals, width*0.8, color=colors[i], edgecolor="none"))
    end
    ax[:set_xticks](ind .+ width*maximum(xcount)/2 + groupSpacing - width*0.1)
    ax[:set_xticklabels](xvalues)

    loc = get(kwargs, :legend, "upper right")
    loc != "none" && ax[:legend](bars, cvalues, frameon=false, loc=loc)
    fig
end
