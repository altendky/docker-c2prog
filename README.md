docker-c2prog
=============

[![GitHub](https://img.shields.io/github/last-commit/altendky/docker-c2prog/main.svg)](https://github.com/altendky/docker-c2prog)
[![Docker Hub](https://img.shields.io/docker/pulls/altendky/c2prog.svg)](https://hub.docker.com/r/altendky/c2prog)

[CodeSkin] develops and distributes reflashing solutions for Texas Instruments C2000 MCUs.
Their application [C2Prog] is able to flash the embedded controller as well as prepare files for use when flashing.
This project makes C2Prog easily available in a Linux Docker image intended for use in your CI system.


Usage
-----

`C2ProgShell` can be run both via this image's entry point and via the `C2ProgShell` command inside the image.
To be useful, files will need to both be made available to C2Prog inside the docker image as well the result made available outside.
`/targets` has been symlinked to the C2Prog targets directory to ease injection of any custom `.xml` target file to be used.
Wine makes the container's `/` available to C2Prog as `z:/` so you can easily reference any files you mount into a subdirectory of the root directory.

In the example below, the file `./custom_demo.xml` is added into the C2Prog targets directory via the `/targets` symlink.
`./test_2838x_c28_cpu01.out` is available via `/data` in Linux which is `z:/data` in Wine.
The result is written to `z:/data/result.ehx` which is `./result.ehx` outside of Docker.
Permissions and ownership can be a bit weird crossing the boundary between the inside and the outside of the Docker container.
In this case we end up with `./result.ehx` being owned by root.

While this example shows the mechanics of using this Docker image to access C2Prog.
It is not intended as a guide to all the arguments you may need to pass to `C2ProgShell`.
Consider any other parameters you may need such as keys and passwords.
Treat your secrets with care.

```console
example$ ls -l
total 644
-rw-rw-r-- 1 altendky altendky   3062 Mar 10 09:07 custom_demo.xml
-rw-rw-r-- 1 altendky altendky  13598 Mar 10 09:07 test_2838x_c28_cpu01.ehx
-rw-rw-r-- 1 altendky altendky 636396 Mar 10 09:07 test_2838x_c28_cpu01.out
```

```console
example$ docker run --volume "$(pwd)/custom_demo.xml":/targets/custom_demo.xml --volume "$(pwd)":/data --rm altendky/c2prog:latest -create="z:/data/result.ehx" -bin="z:/data/test_2838x_c28_cpu01.out" -target=28388,6,4-CPU1_XBL-Demo
C2Prog 1.8.10-6-g1ba3f84 (c) CodeSkin LLC
    running with JRE-version 1.7.0_80

0009:err:module:import_dll Library C5Lua-md_32.dll (which is needed by L"C:\\Program Files (x86)\\C2Prog\\lib\\C5cjson-md_32.dll") not found
0009:err:module:import_dll Library C5Lua-md_32.dll (which is needed by L"C:\\Program Files (x86)\\C2Prog\\lib\\C5EmuLua-md_32.dll") not found
Loading: C:\Program Files (x86)\C2Prog\lib\C5Core-md_32
Native Q5Core DLL version: 0.10
EHX file created.
```

```console
example$ ls -l
total 660
-rw-rw-r-- 1 altendky altendky   3062 Mar 10 09:07 custom_demo.xml
-rw-r--r-- 1 root     root      13598 Mar 10 09:16 result.ehx
-rw-rw-r-- 1 altendky altendky  13598 Mar 10 09:07 test_2838x_c28_cpu01.ehx
-rw-rw-r-- 1 altendky altendky 636396 Mar 10 09:07 test_2838x_c28_cpu01.out
```


Licenses
--------

For C2Prog, CodeSkin provides the [C2Prog license].
This Docker project uses the MIT license.


[CodeSkin]: https://www.codeskin.com/
[C2Prog]: https://www.codeskin.com/programmer
[C2Prog license]: https://www.codeskin.com/wp-content/uploads/2012/07/C2Prog-License.pdf
