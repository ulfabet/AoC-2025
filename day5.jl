# day5.jl - Advent of Code 2025

function parse_ranges(lines)
    empty = findfirst(==(""), lines)
    lines = lines[1:empty-1]
    [range(a, b) for (a,b) in lines .|> l->split(l, "-") .|> s->parse(Int, s)]
end

function parse_available(lines)
    empty = findfirst(==(""), lines)
    lines = lines[empty+1:end]
    lines .|> s->parse(Int, s)
end

function part1(ranges, available)
    function is_fresh(id)
        any(ranges .|> range->id in range)
    end
    sum(available .|> is_fresh)
end

function part2(ranges, available)
    function overlapping(r1, r2)
        !(r1.stop < r2.start || r1.start > r2.stop)
    end
    function merge(r1, r2)
        min(r1.start, r2.start):max(r1.stop, r2.stop)
    end
    function combine(ranges)
        result = []
        for i in 1:length(ranges)
            merged = false
            for j in i+1:length(ranges)
                if overlapping(ranges[i], ranges[j])
                    ranges[j] = merge(ranges[i], ranges[j])
                    merged = true
                end
            end
            if !merged
                push!(result, ranges[i])
            end
        end
        result
    end
    sum(map(length, combine(ranges)))
end

lines = readlines("day5.input")
ranges = parse_ranges(lines)
available = parse_available(lines)
part1(ranges, available) |> println
part2(ranges, available) |> println
