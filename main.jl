# using CairoMakie

function add_one!(d::Dict, c)
    if !haskey(d, c)
        d[c] = 1
    else 
        d[c] += 1
    end
end

sort_by_value(d::Dict) = sort(collect(d), by=x->x[2], rev=true)

function analyze(path::String)
    result = Dict{Char, Float32}()
    char_count = 1
    match_count = 0
    for s in eachline(path)
        i = firstindex(s)
        while i < lastindex(s)
            curr = s[i]
            i = nextind(s, i)
            if Int(curr) < 0x4e00 || 0x9fff < Int(curr)
                println("skip: $curr")
                continue
            end

            char_count += 1
            if curr == s[i]
                add_one!(result, s[i])
                i = nextind(s, i)
                char_count += 1
                match_count += 1
            end
        end
    end
    # frequency per 100,000 characters
    for (k, v) in result
        result[k] = v / char_count * 100_000
    end
    (total= char_count,freq= match_count/char_count, dist= result |> sort_by_value)
end

# function analyze_h(path::String)
#     result = Dict{String, Int64}()
#     for s in eachline(path)
#         split_s = split(s, " ")
#         for word in split_s
#             add_one(result, word)
#         end
#     end
#     sort_by_value(result)
# end

open("result.txt","w") do out
    println(out, analyze("data/詩經.txt"))
end

