# 
# day2.jl - Advent of Code 2025
#

function is_invalid(id, limit)
    s = string(id)
    n = (limit > 0) ? limit : length(s)
    return s in @views map((i) -> s[1:end÷i]^i, 2:n)
end

function calculate(ranges, f)
    total = 0
    for (start, stop) in ranges
        total += sum(filter(f, collect(start:stop)))
    end
    println(total)
end

open("day2.input") do file
    for line in readlines(file)
        ranges = [[parse(Int64, n) for n in split(range, "-")] for range in split(line, ",")] 
        calculate(ranges, (id) -> is_invalid(id, 2)) # part1
        calculate(ranges, (id) -> is_invalid(id, 0)) # part2
    end
end
