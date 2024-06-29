//! based on: https://pixi.sh/latest/examples/cpp-sdl/
const std = @import("std");
const sdl2 = @cImport(@cInclude("SDL2/SDL.h"));

pub fn main() void {

    // Initialize SDL2
    if (sdl2.SDL_Init(sdl2.SDL_INIT_VIDEO) != 0) {
        std.log.err("SDL_Init Error: {s}\n", .{sdl2.SDL_GetError()});
        std.posix.exit(1);
    }
    defer sdl2.SDL_Quit();

    // Create a SDL_Window
    const win = sdl2.SDL_CreateWindow(
        "Basic Pixi SDL project",
        sdl2.SDL_WINDOWPOS_UNDEFINED,
        sdl2.SDL_WINDOWPOS_UNDEFINED,
        800,
        600,
        sdl2.SDL_WINDOW_SHOWN,
    );
    if (win == null) {
        std.log.err("SDL_CreateWindow Error: {s}\n", .{sdl2.SDL_GetError()});
        std.posix.exit(1);
    }
    defer sdl2.SDL_DestroyWindow(win);

    // Create a SDL_Renderer
    const ren = sdl2.SDL_CreateRenderer(
        win,
        -1,
        sdl2.SDL_RENDERER_ACCELERATED,
    );
    if (ren == null) {
        std.log.err("SDL_CreateRenderer Error: {s}\n", .{sdl2.SDL_GetError()});
        std.posix.exit(1);
    }
    defer sdl2.SDL_DestroyRenderer(ren);

    // Declare rect of square
    var squareRect: sdl2.SDL_Rect = .{
        .h = 300,
        .w = 300,
    };

    // Square position: In the middle of the screen
    squareRect.x = @intCast(400 - @divExact(squareRect.w, 2));
    squareRect.y = @intCast(300 - @divExact(squareRect.h, 2));

    // Render the SDL_Texture to the SDL_Window, repeatedly
    var quit = false;
    var e: sdl2.SDL_Event = undefined;
    while (!quit) {
        _ = sdl2.SDL_WaitEvent(&e);

        if (e.type == sdl2.SDL_QUIT)
            quit = true;

        _ = sdl2.SDL_SetRenderDrawColor(ren, 0xFF, 0xFF, 0xFF, 0xFF);
        _ = sdl2.SDL_RenderClear(ren);
        _ = sdl2.SDL_SetRenderDrawColor(ren, 0xFF, 0x00, 0x00, 0xFF);
        _ = sdl2.SDL_RenderFillRect(ren, &squareRect);
        sdl2.SDL_RenderPresent(ren);
    }
}
