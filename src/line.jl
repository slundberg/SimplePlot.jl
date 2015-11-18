function line(;kwargs...)
    kwargs = Dict(kwargs)
    fig,ax = subplots(figsize=get(kwargs, :figsize, (6, 4)))
    set_axis_defaults(ax; kwargs...)

    x = kwargs[:x]
    y = kwargs[:y]
    color = kwargs[:color]
    colors = get(kwargs, :colors, defaultColors)
    cvalues = unique(color)
    lines = Any[]
    for (i,c) in enumerate(cvalues)
        p = ax[:plot](x[color .== c], y[color .== c], color=colors[i], linewidth=2)
        push!(lines, p[1]) # oddity of matplotlib requires the dereference
    end

    loc = get(kwargs, :legend, "upper right")
    loc != "none" && ax[:legend](lines, cvalues, frameon=false, loc=loc)
    fig
end
