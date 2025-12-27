# 
# day4.jl - Advent of Code 2025
#

function neighbours(A, ci)
    indices = CartesianIndices((-1:1, -1:1)) .+ ci
    [A[i] for i in intersect(CartesianIndices(A), indices) if i != ci]
end

function part1(grid)
    adjacent = findall(==('@'), grid) .|>
    index -> neighbours(grid, index) |>
    data -> count(==('@'), data)
    count(<(4), adjacent)
end

function part2(grid)
    removed_rolls = 0
    before = copy(grid)
    coords = findall(==('@'), grid)
    for c in coords
        if count(==('@'), neighbours(before, c)) < 4
            grid[c] = 'x'
            removed_rolls += 1
        end
    end
    removed_rolls == 0 ? 0 : removed_rolls + part2(grid)
end

grid = stack(readlines("day4.input"))
part1(grid) |> println
part2(grid) |> println
