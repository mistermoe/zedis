const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buffer: [1024]u8 = undefined;

    while (true) {
        try stdout.print("> ", .{});
        if (try stdin.readUntilDelimiterOrEof(buffer[0..], '\n')) |user_input| {
            const trimmed = std.mem.trim(u8, user_input, &std.ascii.whitespace);
            if (std.mem.eql(u8, trimmed, "exit")) {
                break;
            }
            try processCommand(trimmed, stdout);
        } else {
            break;
        }
    }
}

fn processCommand(command: []const u8, stdout: anytype) !void {
    var iter = std.mem.split(u8, command, " ");
    const cmd = iter.next() orelse {
        try stdout.print("Invalid command\n", .{});
        return;
    };

    if (std.mem.eql(u8, cmd, "GET")) {
        const key = iter.next() orelse {
            try stdout.print("GET command requires a key\n", .{});
            return;
        };
        try stdout.print("Value for key '{s}'\n", .{key});
    } else if (std.mem.eql(u8, cmd, "SET")) {
        const key = iter.next() orelse {
            try stdout.print("SET command requires a key and value\n", .{});
            return;
        };
        const value = iter.next() orelse {
            try stdout.print("SET command requires a value\n", .{});
            return;
        };
        try stdout.print("Set key '{s}' to value '{s}'\n", .{ key, value });
    } else {
        try stdout.print("Unknown command: {s}\n", .{cmd});
    }
}
