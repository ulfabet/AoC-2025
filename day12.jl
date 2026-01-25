# day12.jl - Advent of Code 2025

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

    function possible(problem)
        rows, cols, nshapes... = problem
        required = sum.(shapes)'nshapes
        aligned_area = (rows ÷ 3) * (cols ÷ 3) * 9
        if required > rows * cols
            return false
        elseif sum(nshapes) * 9 <= aligned_area
            return true
        else
            throw("not implemented")
        end
    end

    [possible(p) for p in problems] |> sum
end

lines = readlines("day12.input")
lines |> part1 |> println
