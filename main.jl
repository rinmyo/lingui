using Printf

function analyze!(path::String)
    char_count = 1
    match_count = 0
    for s in eachline(path)
        i = firstindex(s)
        while i < lastindex(s)
            curr = s[i]
            i = nextind(s, i)
            if Int(curr) < 0x4e00 || 0x9fff < Int(curr) || curr == '有' || curr == '使' || curr == '之'
                # println("skip: $curr")
                continue
            end

            char_count += 1
            if curr == s[i]
                i = nextind(s, i)
                char_count += 1
                match_count += 1
            end
        end
    end

    (
        total=char_count,
        matched=match_count,
    )
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

function log(prefix, total, matched)
    println("$prefix: total: $total, matched: $matched, ratio: $(matched/total)")
end

function run(f, int, label)
    sum_total = 0
    sum_matched = 0
    for i in int
        (total, matched) = analyze!(f(i))
        sum_total += total
        sum_matched += matched
    end
    log(label, sum_total, sum_matched)
end

run( _ -> "data/詩經.txt", 1:1, "詩經")

run(1:10, "楚辭") do i
    "data/KR4a0001/KR4a0001_$(@sprintf "%03d" i).txt"
end

run(0:900, "全唐詩") do i
    "data/KR4h0140/KR4h0140_$(@sprintf "%03d" i).txt"
end

run(1:130, "史記") do i
    "data/shiji/zh-tw/$(@sprintf "%03d" i).md"
end

run(0:101, "漢書") do i
    "data/KR2a0007/KR2a0007_$(@sprintf "%03d" i).txt"
end

run(1:187, "舊唐書") do i
    "data/KR2a0026/KR2a0026_$(@sprintf "%03d" i).txt"
end