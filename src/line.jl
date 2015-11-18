function line(;
        x=nothing, y=nothing, color=nothing,
        colors=["#3366CC", "#DC3912", "#FF9902", "#0C9618"],
    legendLoc="upper right", figsize=(6, 4), xlabel=nothing, ylabel=nothing)
    xvalues = unique(x)
    xcount = Int64[sum(x .== v) for v in xvalues]

    cvalues = unique(color)
    
    fig,ax = subplots(figsize=figsize)
    ax[:spines]["right"][:set_visible](false)
    ax[:spines]["top"][:set_visible](false)
    ax[:yaxis][:set_ticks_position]("left")
    ax[:xaxis][:set_ticks_position]("none")
    ind = 1:length(xvalues)
    width = 1/length(cvalues) * 0.8
    groupSpacing = 0.2

    lines = Any[]
    for (i,c) in enumerate(cvalues)
        push!(lines, ax[:plot](x[color .== c], y[color .== c], color=colors[i], linewidth=2)[1])
    end
    if legendLoc != "none"
        ax[:legend](lines, cvalues, frameon=false)
    end
    if xlabel != nothing
        ax[:set_xlabel](xlabel)
    end
    if ylabel != nothing
        ax[:set_ylabel](ylabel)
    end
    fig
end
