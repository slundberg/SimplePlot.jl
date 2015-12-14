
export grid

type Grid
    params::Dict{Any,Any}
    unusedParams::Dict{Any,Any}
end

param(grid::Grid, symbol) = get(grid.params, symbol, get(gridDefaults, symbol, nothing))
defaults(grid::Grid) = gridDefaults
gridDefaults = Dict(
    :blocks => nothing,
    :rows => 1,
    :cols => 1
)

"Create a new grid with the given blocks and attributes."
function grid(; kwargs...)
    kwargs = Dict(kwargs)
    Grid(get_params(gridDefaults, kwargs)...)
end
function grid(rows::Integer, cols::Integer, blocks...; kwargs...)
    kwargs = Dict(kwargs)

    # make sure all layers are wrapped in an axis
    wrappedBlocks = Any[]
    for b in blocks
        push!(wrappedBlocks, typeof(b) <: Layer ? axis(b) : b)
    end

    kwargs[:blocks] = wrappedBlocks
    kwargs[:rows] = rows
    kwargs[:cols] = cols
    grid(;kwargs...)
end
function grid(firstBlock::Union{Layer,Axis,Grid}, blocks...; kwargs...)
    kwargs = Dict(kwargs)
    grid(1, length(blocks)+1, firstBlock, blocks...; kwargs...)
end

function draw(fig, state, grid::Grid)
    newRows = param(grid, :rows)*state[:rows]
    newCols = param(grid, :cols)*state[:cols]
    newRowOffset = param(grid, :rows)*(state[:rowOffset])
    newColOffset = param(grid, :cols)*(state[:colOffset])

    pos = 1
    for i in 1:param(grid, :rows), j in 1:param(grid, :cols)
        #println(i, " ", j)
        if typeof(param(grid, :blocks)[pos]) == Grid
            draw(fig, Dict(
                :rows => newRows,
                :cols => newCols,
                :rowOffset => newRowOffset + i - 1,
                :colOffset => newColOffset + j - 1
            ), param(grid, :blocks)[pos])
        else
            offset = newRowOffset*newCols + newColOffset
            ax = fig[:add_subplot](newRows, newCols, offset + newCols*(i-1) + j)
            draw(ax, Dict(), param(grid, :blocks)[pos])
        end
        pos += 1
    end
end

"Allow unused parameters to apply to things below and above where they are defined."
function propagate_params_down(grid::Grid)
    for block in grid.params[:blocks]
        d1,d2 = get_params(defaults(block), merge(grid.unusedParams, block.unusedParams))
        block.params = merge(d1, block.params)
        block.unusedParams = d2
        propagate_params_down(block)
    end
    grid.unusedParams = Dict() # they will come back up if they are not used below us
end
function propagate_params_up(grid::Grid)
    for block in grid.params[:blocks]
        propagate_params_up(block)
        d1,d2 = get_params(defaults(grid), merge(block.unusedParams, grid.unusedParams))
        grid.params = merge(d1, grid.params)
        grid.unusedParams = d2
    end
end

"This wraps the grid for direct display"
Base.show(io::Base.IO, x::Grid) = Base.show(io, plot(x))

pyplot(x::Grid) = pyplot(plot(x))
save(outPath::AbstractString, x::Grid) = save(outPath, plot(x))
