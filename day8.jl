# day8.jl - Advent of Code 2025

function distances(boxes)
    d = Dict()
    for i in 1:length(boxes)
        for j in i+1:length(boxes)
            a, b = boxes[i], boxes[j]
            d[sum((b-a).^2)] = [a, b]
        end
    end
    sort(collect(d))
end

function connect(boxes)
    circuits = Dict(b => Set([b]) for b in boxes)
    count = 0
    for (d,(a,b)) in distances(boxes)
        count += 1
        circuits[a] = union(circuits[a], circuits[b])
        for e in circuits[a]
            circuits[e] = circuits[a]
        end
        # part 1
        if count == 1000
            sizes = circuits |> values .|> length |> Set |> collect |> sort |> reverse
            prod(sizes[1:3]) |> println
        end
        # part 2
        if length(circuits[a]) == length(circuits)
            a[1]*b[1] |> println
            return
        end
    end
end

boxes = readlines("day8.input") .|> s->split(s, ",") .|> s->parse(Int, s)
connect(boxes)
