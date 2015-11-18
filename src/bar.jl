using PyPlot

function bar(;
        x=nothing, y=nothing, color=nothing,
        colors=["#3366CC", "#DC3912", "#FF9902", "#0C9618"],
        legend="upper right", figsize=(6, 4), xlabel=nothing, ylabel=nothing)
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

    bars = Any[]
    for (i,c) in enumerate(cvalues)
        vals = zeros(length(xvalues))
        for j in 1:length(x)
            if color[j] == c
                vals[findfirst(xvalues, x[j])] = y[j]
            end
        end
        push!(bars, ax[:bar](ind .+ (i-1)*width + groupSpacing, vals, width*0.8, color=colors[i], edgecolor="none"))
    end
    ax[:set_xticks](ind .+ width*maximum(xcount)/2 + groupSpacing - width*0.1)
    ax[:set_xticklabels](("G1", "G2", "G3", "G4", "G5"))
    if legend != "none"
        ax[:legend](bars, cvalues, frameon=false)
    end
    if xlabel != nothing
        ax[:set_xlabel](xlabel)
    end
    if ylabel != nothing
        ax[:set_ylabel](ylabel)
    end
    fig
end
