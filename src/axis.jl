
export axis

type Axis
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(axis::Axis, symbol) = get(axis.params, symbol, get(axisDefaults, symbol, nothing))
defaults(axis::Axis) = axisDefaults
axisDefaults = Dict(
    :layers => nothing,
    :xlabel => nothing,
    :ylabel => nothing,
    :xlim => nothing,
    :ylim => nothing,
    :title => nothing,
    :titley => 1,
    :xticks => nothing,
    :xticklabels => nothing,
    :xtickrotation => "horizontal",
    :xscale => nothing,
    :yticks => nothing,
    :yticklabels => nothing,
    :yscale => nothing,
    :legend => "best",
    :stacked => false,
    :gridaxis => nothing,
    :gridcolor => "#BBBBBB",
    :gridalpha => 1,
    :gridlinewidth => 1,
    :gridlinestyle => "-",
    :spineleft => true,
    :spineright => false,
    :spinetop => false,
    :spinebottom => true,
    :xtickspos => "bottom",
    :ytickspos => "left"
)

"Create a new axis with the given layers and attributes."
function axis(layers...; kwargs...)
    kwargs = Dict(kwargs)
    kwargs[:layers] = [collect(filter(x->x != nothing, layers)); get(kwargs, :layers, Any[])]
    Axis(get_params(axisDefaults, kwargs)...)
end

"This wraps the layer in an axis for direct display"
Base.show(io::Base.IO, x::Axis) = Base.display(plot(grid(x)))

"Create a new axis with the given layers and attributes."
function draw(ax, state, axis::Axis)

    ax[:spines]["right"][:set_visible](param(axis, :spineright))
    ax[:spines]["left"][:set_visible](param(axis, :spineleft))
    ax[:spines]["top"][:set_visible](param(axis, :spinetop))
    ax[:spines]["bottom"][:set_visible](param(axis, :spinebottom))
    ax[:yaxis][:set_ticks_position](param(axis, :ytickspos))
    ax[:xaxis][:set_ticks_position](param(axis, :xtickspos))
    param(axis, :xlabel) != nothing && ax[:set_xlabel](param(axis, :xlabel))
    param(axis, :ylabel) != nothing && ax[:set_ylabel](param(axis, :ylabel))
    param(axis, :xlim) != nothing && ax[:set_xlim](param(axis, :xlim))
    param(axis, :ylim) != nothing && ax[:set_ylim](param(axis, :ylim))
    param(axis, :xticks) != nothing && ax[:set_xticks](param(axis, :xticks))
    param(axis, :xticklabels) != nothing && ax[:set_xticklabels](param(axis, :xticklabels))
    param(axis, :xscale) != nothing && ax[:set_xscale](param(axis, :xscale))
    param(axis, :yticks) != nothing && ax[:set_yticks](param(axis, :yticks))
    param(axis, :yticklabels) != nothing && ax[:set_yticklabels](param(axis, :yticklabels))
    param(axis, :yscale) != nothing && ax[:set_yscale](param(axis, :yscale))
    param(axis, :title) != nothing && ax[:set_title](param(axis, :title), y=param(axis, :titley))
    if param(axis, :gridaxis) != nothing
        ax[:grid](
            axis = param(axis, :gridaxis),
            color = param(axis, :gridcolor),
            alpha = param(axis, :gridalpha),
            linewidth = param(axis, :gridlinewidth),
            linestyle = param(axis, :gridlinestyle)
        )
        ax[:set_axisbelow](true)
    end

    # fill in any missing colors with the defaults
    colorPos = 1
    for l in param(axis, :layers)
        if param(l, :color) == nothing
            l.params[:color] = defaultColors[colorPos]
            colorPos += 1
        end
    end

    # this gives plot type specific methods the chance to see all the data
    # before drawing each layer
    state = Dict() # a place for methods to store state for drawing
    for parser in axisParsers
        parser(ax, state, axis)
    end

    # draw each layer
    plotObjects = Any[]
    for l in reverse(param(axis, :layers))
        unshift!(plotObjects, draw(ax, state, l))
    end

    build_legend(ax, axis, plotObjects)
end

axisParsers = Function[]
"Allow specific plot type to view the whole axis to make layout choices."
function register_axis_parser(f::Function)
    global axisParsers
    push!(axisParsers, f)
end

# "Creates an axis object."
# function build_axis(; kwargs...)
#     kwargs = Dict(kwargs)
#
#     fig,ax = PyPlot.subplots(figsize=get(kwargs, :figsize, (5, 4)))
#
#
#
#     fig,ax
# end

"Allow unused parameters to apply to things below and above where they are defined."
function propagate_params_down(axis::Axis)
    for layer in axis.params[:layers]
        d1,d2 = get_params(defaults(layer), merge(axis.unusedParams, layer.unusedParams))
        layer.params = merge(d1, layer.params)
        layer.unusedParams = d2
    end
    axis.unusedParams = Dict() # they will come back up if they are not used below us
end
function propagate_params_up(axis::Axis)
    for layer in axis.params[:layers]
        d1,d2 = get_params(defaults(axis), merge(layer.unusedParams, axis.unusedParams))
        axis.params = merge(d1, axis.params)
        axis.unusedParams = d2
    end
end

"Adds a legend to the given axis object."
function build_legend(ax, axis, plotObjects)

    # placeholders for legend (because plots like violin don't directly support a legend)
    patches = Any[]
    for l in param(axis, :layers)
        if param(l, :label) != nothing
            push!(patches, mpatches.Patch(color=param(l, :color), label=param(l, :label)))
        end
    end

    mask = Bool[param(l, :label) != nothing for l in param(axis, :layers)]
    loc = param(axis, :legend)
    if loc != "none"
        ax[:legend](handles=patches, frameon=false, loc=loc, handlelength=0.7, handleheight=0.7,
            handletextpad=0.5, fontsize="medium", labelspacing=0.4
        )
    end
end

"This wraps the axis for direct display"
Base.show(io::Base.IO, x::Axis) = Base.show(io, grid(1, 1, x))

pyplot(x::Axis) = pyplot(grid(1, 1, x))
save(outPath::AbstractString, x::Axis) = save(outPath, grid(1, 1, x))
