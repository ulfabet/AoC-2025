# 
# day1.jl - Advent of Code 2025
#

function part1(rotations, dial)
    function turn(value)
        dial += value
        dial %= 100
    end
    println(count(==(0), map(turn, rotations)))
end

function part2(rotations, dial)
    function turn(value)
        result = abs(value÷100)
        if dial > 0 && !(0 < (dial + value%100) < 100)
            result += 1
        end
        if dial < 0 && !(-100 < (dial + value%100) < 0)
            result += 1
        end
        dial += value
        dial %= 100
        result
    end
    println(sum(map(turn, rotations)))
end

open("day1.input") do file
    numbers = [replace(s, "L" => "-", "R" => "") for s in readlines(file)]
    rotations = [parse(Int64, n) for n in numbers]
    part1(rotations, 50)
    part2(rotations, 50)
end
