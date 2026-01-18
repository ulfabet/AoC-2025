# day10.part2.nolib.jl - Advent of Code 2025
#
# - Gaussian elimination to find a general solution for the system of linear equations.
# - In case of free variables, the idea was to solve the system of inequalities (each variable >= 0).
# - Instead, we iteratively locate the valid solution space and perform an exhaustive search for an optimal solution.
# - Eventually got the correct answer and was about to clean up the code, but I abandoned this approach and used JuMP instead.

parse_group = input -> input[2:end-1] |> s->split(s, ",") .|> s->parse(Int, s)
parse_lights = input -> [c == '#' ? 1 : 0 for c in input[2:end-1]]
parse_buttons = input -> input .|> parse_group
parse_joltages = parse_group

function parse_line(line)
    lights, buttons..., joltages = line |> split
    parse_lights(lights), parse_buttons(buttons), parse_joltages(joltages)
end

function rref(M)
    # reduced row echelon form
    M = convert(Matrix{Rational}, M)
    rows, cols = size(M)
    function reorder()
        for i in 1:min(rows, cols)
            p = sortperm(M[i:end,i], lt=(a,b)->abs(a)>abs(b))
            M[i:end,:] = M[p.+(i-1),:]
        end
    end
    function reduce(i)
        k = findfirst(!iszero, M[i,:])
        if k != nothing
            M[i,:] /= M[i,k]
            for j in i+1:rows
                if M[j,k] != 0
                    M[j,:] += M[i,:] * -M[j,k]
                end
            end
        end
    end
    for i in 1:rows
        reorder()
        reduce(i)
    end
    M
end

function diag(M)
    [M[i,i] for i in 1:minimum(size(M))]
end

function solve(buttons, joltages)
    buttons = buttons .|> b->[Int(i in b) for i in 0:length(joltages)-1]
    M = hcat(stack(buttons), joltages) |> rref
    rows, cols = size(M)
    vars = cols-1

    # matrix of solutions with empty rows for unknown variables
    A = zeros(Rational, vars, cols)
    for i in 1:rows
        n = findfirst(!=(0), M[i,1:vars])
        if n != nothing
            A[n,:] = M[i,:]
        end
    end
    
    # free variables
    unknown = findall(iszero, diag(A))

    # substitute (known variables)
    for i in 1:vars-1 |> reverse
        for j in i+1:vars
            A[i,:] -= A[j,:] * A[i,j]
        end
    end

    # solutions depending only on unknown variables
    for i in 1:vars
        A[i,1:vars] = -A[i,1:vars]
        A[i,i] = i in unknown ? 1 : 0
    end

    values = Rational[zeros(vars); 1]
    result = @view values[1:end-1]

    function resolve()
        for i in axes(A,1)
            values[i] = A[i,:]'values
        end
    end

    cache = Dict()
    uval = @view values[unknown]

    # locate valid solution space
    function getpositive(foo)
        if foo in keys(cache)
            return
        end
        cache[copy(foo)] = nothing
        values[unknown] = foo
        resolve()
        if all(>=(0), values)
            return foo
        end
        suspects = []
        diffs = []
        for u in unknown
            for i in axes(A,1)
                if i == u || iszero(A[i,u])
                    continue
                end
                value = A[i,:]'values
                if value < 0
                    values[u] += 1
                    diff = A[i,:]'values - value
                    values[u] -= 1
                    if diff >= 0
                        push!(diffs, diff)
                        push!(suspects, u)
                    end
                end
            end
        end
        for u in suspects[sortperm(diffs) |> reverse]
            values[u] += 1
            r = getpositive(uval)
            if r != nothing
                return r
            end
            values[u] -= 1
        end
    end

    best = 1//0

    # find optimal solution
    function staypositive(foo)
        if foo in keys(cache)
            return
        end
        cache[copy(foo)] = nothing
        values[unknown] = foo
        resolve()
        if any(<(0), values)
            return
        end
        if all(isinteger, result)
            best = min(best, sum(result))
        end
        for offset in Iterators.product(repeat([(-1,0,1)],length(unknown))...) 
            values[unknown] = values[unknown] .+ offset
            staypositive(uval)
            values[unknown] = values[unknown] .- offset
        end
    end

    getpositive(uval)
    cache = Dict()
    staypositive(uval)

    Int(best)
end

function part2(lines)
    [solve(buttons, joltages) for (_, buttons, joltages) in lines .|> parse_line] |> sum
end

lines = readlines("day10.input")
lines |> part2 |> println
