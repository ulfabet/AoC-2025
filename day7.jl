# day7.jl - Advent of Code 2025

const start, splitter = 'S', '^'

function part1((head, tail...))
    beams = Set(findall(start, head))
    count = 0
    for line in tail
        splitters = Set(findall(splitter, line))
        tosplit = intersect(beams, splitters)
        count += length(tosplit)
        beams = setdiff(beams, tosplit)
        beams = union(beams, vcat(tosplit.-1, tosplit.+1))
    end
    count
end

function part2((head, tail...))
    beams = [c == start ? 1 : 0 for c in head]
    for line in tail
        for i in findall(splitter, line)
            n = beams[i]
            beams[i-1] += n
            beams[i+1] += n
            beams[i] = 0
        end
    end
    sum(beams)
end

lines = "day7.input" |> readlines
lines |> part1 |> println
lines |> part2 |> println
