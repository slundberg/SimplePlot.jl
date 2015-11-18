function line(;kwargs...)
    kwargs = Dict(kwargs)
    fig,ax = subplots(figsize=get(kwargs, :figsize, (5, 4)))
    x,y,color = set_defaults(ax; kwargs...)

    colors = get(kwargs, :colors, defaultColors)
    cvalues = unique(color)
    lines = Any[]
    for (i,c) in reverse(collect(enumerate(cvalues)))
        p = ax[:plot](x[color .== c], y[color .== c], color=colors[i], linewidth=3)
        push!(lines, p[1]) # oddity of matplotlib requires the dereference
    end

    loc = get(kwargs, :legend, "upper right")
    loc != "none" && ax[:legend](lines, reverse(cvalues), frameon=false, loc=loc)
    fig
end
