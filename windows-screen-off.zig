const std = @import("std");

// TODO: LPARAM should be isize, not *c_void, because it's defined as a signed integer in C
const LPARAM = isize;

const win = struct {
    usingnamespace std.os.windows;
};

extern "user32" fn SendMessageA(
    hWnd: win.HWND,
    Msg: win.UINT,
    wParam: win.WPARAM,
    lParam: LPARAM
) callconv(.Stdcall) win.LRESULT;

extern "user32" fn PostMessageA(
    hWnd: win.HWND,
    Msg: win.UINT,
    wParam: win.WPARAM,
    lParam: LPARAM
) callconv(.Stdcall) win.BOOL;

const HWND_BROADCAST = @intToPtr(win.HWND, 0xffff);
const WM_SYSCOMMAND = 0x112;
const SC_MONITORPOWER = 0xf170;

pub fn main() void {
    const blocking = false;
    if (blocking) {
        std.log.info("Calling SendMessageA...", .{});
        const result = SendMessageA(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
        std.log.info("SendMessageA returned {}", .{result});
    } else {
        std.log.info("Calling PostMessageA...", .{});
        if (0 == PostMessageA(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2)) {
            std.log.err("PostMessageA failed with {}\n", .{win.kernel32.GetLastError()});
        } else {
            std.log.info("PostMessageA Success", .{});
        }
    }
    std.log.info("TODO: disable mouse input?", .{});
}
