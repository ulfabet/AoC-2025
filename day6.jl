# day6.jl - Advent of Code 2025

operations = Dict("*" => (a,b) -> a*b, "+" => (a,b) -> a+b)

function calculate((numbers..., operation))
    reduce(operations[operation], numbers .|> s->parse(Int, s))
end

function part1(lines)
    lines .|> split |> stack |> eachrow .|> calculate |> sum 
end

function part2(lines)
    result = 0
    problem = []
    for (n..., op) in lines |> stack |> eachrow |> reverse
        s = n |> join |> strip
        if isempty(s)
            continue
        end
        push!(problem, s)
        if op != ' '
            push!(problem, string(op))
            result += calculate(problem)
            empty!(problem)
        end
    end
    result
end

lines = readlines("day6.input")
part1(lines) |> println
part2(lines) |> println
