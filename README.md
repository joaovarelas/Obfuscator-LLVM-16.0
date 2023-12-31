# Obfuscator-LLVM-16.0


## Quick Usage

Get the Docker image and run:


```bash
docker pull ghcr.io/joaovarelas/obfuscator-llvm-16.0:latest
docker run -v  /path/to/cargo/proj:/projects/ -it <image-id> /bin/bash

# target windows
cargo rustc --target x86_64-pc-windows-gnu --release -- -Cdebuginfo=0 -Cstrip=symbols -Cpanic=abort -Copt-level=3 -Cllvm-args=-enable-allobf

# target linux
cargo rustc --target x86_64-unknown-linux-gnu --release -- -Cdebuginfo=0 -Cstrip=symbols -Cpanic=abort -Copt-level=3 -Cllvm-args=-enable-allobf
```

Compiled binaries will be placed at `./target` directory.


## Available OLLVM Features

Current Rust OLLVM is based on [Hikari](https://github.com/61bcdefg/Hikari-LLVM15-Core/blob/main/Obfuscation.cpp) which has the following features:

- Anti Class Dump: `-enable-acdobf`
- Anti Hooking: `-enable-antihook`
- Anti Debug: `-enable-adb`
- Bogus Control Flow: `-enable-bcfobf`
- (*) Control Flow Flattening: `-enable-cffobf`
- Basic Block Splitting: `-enable-splitobf`
- Instruction Substitution: `-enable-subobf`
- Function CallSite Obf: `-enable-fco`
- (*) String Encryption: `-enable-strcry`
- Constant Encryption: `-enable-constenc`
- (*) Indirect Branching: `-enable-indibran`
- (*) Function Wrapper: `-enable-funcwra`

- Enable ALL of the above: `-enable-allobf` (not going to work and you'll probably run out of memory)


_* not working_



## Development 

_TO-DO_


## Contributors

- [@eduardo010174](https://github.com/eduardo010174)
- [@joaovarelas](https://github.com/joaovarelas)






