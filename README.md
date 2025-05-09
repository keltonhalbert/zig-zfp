[![Build](https://github.com/allyourcodebase/zfp/actions/workflows/ci.yaml/badge.svg)](https://github.com/allyourcodebase/zfp/actions/workflows/ci.yaml)
# zfp-zig: zfp packaged for the Zig programming language
This is the [ZFP C compression library](https://github.com/LLNL/zfp) for the [Zig](https://ziglang.org/) programming language. Currently does not wrap the C++ compressed array classes.

# How do I include it in my Zig program?
If you are starting a new package: 
```bash

mkdir my_project; cd my_project
zig init
## add the package to 'build.zig.zon'
zig fetch --save=zfp git+https://github.com/allyourcodebase/zfp.git
```
This will add the zig C library as a dependency to your project. 
Next, if you are linking it to a library or executable, add the following to **build.zig**:
```Zig
pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const zfp_dep = b.dependency("zfp", .{
        .target = target,
        .optimize = optimize,
    });

    // if you are linking it to a library...
    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib_mod.linkLibrary(zfp_dep.artifact("zfp"));
        
    // or, if you are linking it to an executable...
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.linkLibrary(zfp_dep.artifact("zfp"));
}
```
# Requirements
The target version of Zig is ```0.14```. It may work with earlier versions, but has not been tested.
