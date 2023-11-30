# Obfuscator-LLVM-16.0


NOTE: You are going to need at least **30GB** of disk space and patience to compile LLVM 16.


1. `git clone https://github.com/joaovarelas/Obfuscator-LLVM-16.0 && cd Obfuscator-LLVM-16.0`
2. `docker build -t rustc-ollvm .`
3. `docker run -v /path/to/my/cargo/projects:/projects/ -it rustc-ollvm:latest /bin/bash`

Then inside the container:

4. `cd /projects/myproject/`
5. `RUSTCFLAGS="-Cllvm-args=-enable-allobf" cargo +ollvm-rust-1.70.0 build --release`

The executables will be placed at `target/`.




OLLVM 16.0 patch for Rust LLVM based on Hikari

- https://github.com/rust-lang/llvm-project/tree/rustc/16.0-2023-03-06
- Commit: 2b9c52f66815bb8d6ea74a4b26df3410602be9b0



