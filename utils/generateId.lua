function generateId(type, counter)
    return ("{%s}/rlzMenu:%s:%s/%s"):format(
        GetCurrentResourceName(),
        type,
        counter,
        math.random(100000, 999999)
    )
end