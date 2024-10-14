const std = @import("std");
const zedis = @import("zedis");

pub fn main() !void {
    const greeting = zedis.hi();
    std.debug.print("{s}", .{greeting});
}
