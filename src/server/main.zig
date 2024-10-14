// learning from https://www.openmymind.net/TCP-Server-In-Zig-Part-1-Single-Threaded/

const std = @import("std");
const net = std.net;
const posix = std.posix;

pub fn main() !void {
    const address = try std.net.Address.parseIp("127.0.0.1", 6379);
    const tpe = posix.SOCK.STREAM;
    const protocol = posix.IPPROTO.TCP;

    const listener = try posix.socket(address.any.family, tpe, protocol);
    defer posix.close(listener);

    try posix.setsockopt(listener, posix.SOL.SOCKET, posix.SO.REUSEADDR, &std.mem.toBytes(@as(c_int, 1)));
    try posix.bind(listener, &address.any, address.getOsSockLen());

    try posix.listen(listener, 128);

    while (true) {
        var client_address: net.Address = undefined;
        var client_address_len: posix.socklen_t = @sizeOf(net.Address);

        const socket = posix.accept(listener, &client_address.any, &client_address_len, 0) catch |err| {
            std.debug.print("error accepting connection: {}\n", .{err});
            continue;
        };
        defer posix.close(socket);

        std.debug.print("accepted connection with {}\n", .{client_address});

        write(socket, "Hi2u!") catch |err| {
            std.debug.print("error writing: {}\n", .{err});
        };
    }
}

fn write(socket: posix.fd_t, msg: []const u8) !void {
    var pos: usize = 0;

    while (pos < msg.len) {
        const written = try posix.write(socket, msg[pos..]);
        if (written == 0) {
            return error.Closed;
        }

        pos += written;
    }
}
