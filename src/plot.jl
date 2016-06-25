
export plot

type Plot
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end
param(plot::Plot, symbol) = get(plot.params, symbol, get(plotDefaults, symbol, nothing))
defaults(plot::Plot) = plotDefaults
plotDefaults = Dict(
    :grid => nothing,
    :figsize => (5, 4)
)

"Create a new plot with the given grid."
function plot(; kwargs...)
    kwargs = Dict(kwargs)
    Plot(get_params(plotDefaults, kwargs)...)
end
function plot(grid; kwargs...)
    kwargs = Dict(kwargs)
    kwargs[:grid] = grid
    plot(;kwargs...)
end

"Create a PyPlot object from a Plot object."
function pyplot(plot::Plot)

    # propagate all the unused parameters down and then up
    # this allows higher level objects to set params for all
    # their children, and for lower level objects to set params
    # for implicit higher level wrappers
    propagate_params_down(plot)
    propagate_params_up(plot)

    #print_params(plot)

    # create a PyPlot figure and draw onto it
    fig = PyPlot.figure(figsize=param(plot, :figsize))
    draw(fig, Dict(
        :rows => 1,
        :cols => 1,
        :rowOffset => 0,
        :colOffset => 0
    ), param(plot, :grid))

    PyPlot.close(fig) # prevent the plot from being displayed prematurely

    fig
end

"Allow unused parameters to apply to things below and above where they are defined."
function propagate_params_down(plot::Plot)
    grid = param(plot, :grid)
    d1,d2 = get_params(defaults(grid), merge(plot.unusedParams, grid.unusedParams))
    grid.params = merge(d1, grid.params)
    grid.unusedParams = d2
    propagate_params_down(grid)
    plot.unusedParams = Dict() # they will come back up if they are not used below us
end
function propagate_params_up(plot::Plot)
    grid = param(plot, :grid)
    propagate_params_up(grid)
    d1,d2 = get_params(defaults(plot), merge(grid.unusedParams, plot.unusedParams))
    plot.params = merge(d1, plot.params)
    plot.unusedParams = d2
end

"This wraps the plot for direct display"
Base.show(io::Base.IO, x::Plot) = Base.display(pyplot(x))

save(outPath::AbstractString, x::Plot) = save(outPath, pyplot(x))
