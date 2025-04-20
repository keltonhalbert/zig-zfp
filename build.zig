const std = @import("std");

pub fn build(b: *std.Build) void {
    const upstream = b.dependency("zfp", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zfp_mod = b.createModule(.{
        // `root_source_file` is the Zig "entry point" of the module. If a module
        // only contains e.g. external object files, you can make this `null`.
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/zfp.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "zfp",
        .root_module = zfp_mod,
        .root_source_file = b.path("src/zfp.zig"),
    });

    lib.linkLibC();
    lib.addIncludePath(upstream.path("include"));

    lib.addCSourceFiles(.{ .root = upstream.path("src"), .files = &.{
        "bitstream.c",
        "decode1d.c",
        "decode1f.c",
        "decode1i.c",
        "decode1l.c",
        "decode2d.c",
        "decode2f.c",
        "decode2i.c",
        "decode2l.c",
        "decode3d.c",
        "decode3f.c",
        "decode3i.c",
        "decode3l.c",
        "decode4d.c",
        "decode4f.c",
        "decode4i.c",
        "decode4l.c",
        "encode1d.c",
        "encode1f.c",
        "encode1i.c",
        "encode1l.c",
        "encode2d.c",
        "encode2f.c",
        "encode2i.c",
        "encode2l.c",
        "encode3d.c",
        "encode3f.c",
        "encode3i.c",
        "encode3l.c",
        "encode4d.c",
        "encode4f.c",
        "encode4i.c",
        "encode4l.c",
        "zfp.c",
    }, .flags = &.{
        "-fPIC",
        "-std=c99",
    } });

    lib.installHeadersDirectory(upstream.path("include"), "", .{
        .include_extensions = &.{
            "zfp.h",
        },
    });

    b.installArtifact(lib);
}
