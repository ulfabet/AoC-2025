# day10.jl - Advent of Code 2025

using JuMP
import HiGHS

parse_group = input -> input[2:end-1] |> s->split(s, ",") .|> s->parse(Int, s)
parse_lights = input -> [c == '#' ? 1 : 0 for c in input[2:end-1]]
parse_buttons = input -> input .|> parse_group
parse_joltages = parse_group

function parse_line(line)
    lights, buttons..., joltages = line |> split
    parse_lights(lights), parse_buttons(buttons), parse_joltages(joltages)
end

function part1(lines)
    function presses(lights, buttons)
        result = []
        buttons = [[Int(i in b) for i in 0:length(lights)-1] for b in buttons]
        n = length(buttons)
        for i in 0:2^n-1
            bits = digits(i, base=2, pad=length(buttons))
            pressed = buttons[findall(==(1), bits)]
            value = foldl((a,b)->a .⊻ b, pressed, init=zero(lights))
            if value == lights
                push!(result, sum(bits))
            end
        end
        result
    end
    [presses(lights, buttons) for (lights, buttons, _) in lines .|> parse_line] .|> minimum |> sum
end

function part2(lines)
    function solve(buttons, joltages)
        m = Model(HiGHS.Optimizer); set_silent(m)
        A = [[Int(i in b) for i in 0:length(joltages)-1] for b in buttons] |> stack
        b = joltages
        @variable(m, x[eachindex(buttons)] >= 0, Int)
        @constraint(m, A * x .== b)
        @objective(m, Min, sum(x))
        optimize!(m)
        objective_value(m)
    end
    [solve(buttons, joltages) for (_, buttons, joltages) in lines .|> parse_line] |> sum |> Int
end

lines = readlines("day10.input")

lines |> part1 |> println
lines |> part2 |> println
