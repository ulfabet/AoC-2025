# 
# day3.jl - Advent of Code 2025
#

function joltage(batteries, n)
    total = 0
    offset = 0
    for i in 1:n
        joltage, index = findmax(batteries[offset+1:end-(n-i)])
        offset += index
        total += joltage*10^(n-i)
    end
    total
end

function parse_batteries(bank)
    [parse(Int64, n) for n in split(bank, "")]
end

open("day3.input") do file
    banks = readlines(file)
    for n in [2, 12]
        result = sum([joltage(parse_batteries(bank), n) for bank in banks])
        println(result)
    end
end
