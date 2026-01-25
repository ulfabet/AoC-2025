# day12.jump.jl - Advent of Code 2025
#
# - Model every possible placement of each shape and use constraints to limit possible combinations
# - Works for the example input, but is way too slow for the real input

using JuMP
import HiGHS

function constraint(variants, row, col, rows, cols)
    # returns [[row, col, shape, variant]...]
    result = []
    for (i, shapes) in variants |> enumerate
        for (j, s) in shapes |> enumerate
            for c in CartesianIndex(1+row,1+col) .- findall(==(true), s)
                push!(result, [c[1], c[2], i, j])
            end
        end
    end
    result = filter(a->all(>(0), a), result)
    filter(a->(a[1]<=rows-2 && a[2]<=cols-2), result)
end

function part1(lines)

    offset = 1

    function parse_shape()
        offset += 5
        lines[offset-4:offset-2] |> stack .== '#'
    end

    function parse_problems()
        [replace(line, r"[x:]" => " ") |> split .|> s->parse(Int, s) for line in lines[offset:end]]
    end

    shapes = [parse_shape() for i in 1:6]
    problems = parse_problems()

    # add rotated and flipped variants
    variants = []
    for (i, s) in shapes |> enumerate
        push!(variants, Set())
        for j in 1:4
            push!(variants[i], s)
            push!(variants[i], reverse(s, dims=1))
            s = rotl90(s)
        end
    end
    
    variants = [collect(s) for s in variants]

    function possible(problem)
        rows, cols, nshapes... = problem
        println("area: $(rows)x$(cols), shapes $nshapes")
        m = Model(HiGHS.Optimizer); set_silent(m)
        # each possible placement of each shape
        @variable(m, z[1:rows-2, 1:cols-2, i = eachindex(variants), eachindex(variants[i])], Bin)
        for (i, n) in nshapes |> enumerate
            # given number of shapes of each type
            @constraint(m, sum(z[1:rows-2, 1:cols-2, i, eachindex(variants[i])]) == n)
        end
        for row in 1:rows, col in 1:cols
            c = constraint(variants, row, col, rows, cols)
            # number of placed shapes at each coordinate <= 1
            @constraint(m, sum(z[c[k][1], c[k][2], c[k][3], c[k][4]] for k in eachindex(c)) <= 1)
        end
        @objective(m, Max, sum(z))
        optimize!(m)
        is_solved_and_feasible(m)
    end

    return [possible(p) for p in problems] |> sum

end

lines = readlines("day12.example")
# lines = readlines("day12.input")
lines |> part1 |> println
