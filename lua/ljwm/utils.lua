--- Small utilities.

--- A print function with format string, much like the C version.
function printf(fmt, ...)
    io.write(string.format(fmt, ...));
end


