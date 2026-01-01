# day9.jl - Advent of Code 2025

function boxes(v)
    [v[[i,j]] for i in 1:length(v)-1 for j in i+1:length(v)]
end

function area(box)
    prod(abs.(box[2]-box[1]).+1)
end

function part1(points)
    boxes(points) .|> area |> maximum
end

function unit(v)
    [e == 0 ? 0 : e ÷ abs(e) for e in v]
end

function bounds(points)
    left, right, up, down = [-1,0], [1,0], [0,-1], [0,1]
    result = []
    n = length(points)
    for i in 1:n
        prev, curr, next = points[mod1.(i-1:i+1, n)]
        dn = unit(next-curr)
        dp = unit(curr-prev)
        # clockwise
        if (dp == up && dn == right) || (dp == right && dn == down) || (dp == down && dn == left) || (dp == left && dn == up)
	    curr += dp - dn;
        end
        # anti-clockwise
        if (dp == up && dn == left) || (dp == left && dn == down) || (dp == down && dn == right) || (dp == right && dn == up)
            curr += dn - dp;
        end
        push!(result, curr)
    end
    result
end

function boundingboxes(bounds)
    result = []
    for i in 1:length(bounds)
        a = bounds[i]
        b = bounds[mod1(i+1, length(bounds))]
        push!(result, (min.(a, b), max.(a, b)))
    end
    result
end

function overlappingRectangles(l1, r1, l2, r2)
    if l1[1] > r2[1] || l2[1] > r1[1] || l1[2] > r2[2] || l2[2] > r1[2]
        return false
    else
        return true
    end
end

function inside(bounds, box)
    a, b = box
    l1 = min.(a, b)
    r1 = max.(a, b)
    overlapping((l2, r2)) = overlappingRectangles(l1, r1, l2, r2)
    bounds .|> overlapping |> !any
end

function part2(points)
    bb = boundingboxes(bounds(points))
    insidebounds(box) = inside(bb, box)
    boxes(points) |> filter(insidebounds) .|> area |> maximum
end

points = readlines("day9.input") .|> s->split(s, ",") .|> s->parse(Int, s)
part1(points) |> println
part2(points) |> println
