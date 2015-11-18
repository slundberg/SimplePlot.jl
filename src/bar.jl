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
    width = 1/maximum(xcount) * 0.8
    groupSpacing = 0.2

    # find which colors are present at each x value
    cgroups = Any[]
    for i in 1:length(xvalues)
        push!(cgroups, color[find(x .== xvalues[i])])
    end
    
    bars = Any[]
    for (i,c) in enumerate(cvalues)
        vals = ones(length(xvalues))*Inf
        vals = Float64[]
        pos = Float64[]
        for j in 1:length(xvalues)
            cind = findfirst(cgroups[j] .== c)
            if cind != 0
                push!(pos, j + (cind-1)*width + groupSpacing)
                push!(vals, y[findfirst((color .== c) .* (x .== xvalues[j]))])
            end
        end
        push!(bars, ax[:bar](pos, vals, width*0.8, color=colors[i], edgecolor="none"))
    end
    ax[:set_xticks](ind .+ width*maximum(xcount)/2 + groupSpacing - width*0.1)
    ax[:set_xticklabels](xvalues)

    loc = get(kwargs, :legend, "upper right")
    loc != "none" && ax[:legend](bars, cvalues, frameon=false, loc=loc)
    fig
    1
end
