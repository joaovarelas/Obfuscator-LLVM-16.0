FROM rust:1.70.0-bullseye


# install dependencies
RUN apt update -y
RUN apt install -y cmake ninja-build libc6 libc6-dev git gcc clang-11 python3 gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64

# get source code for rust-llvm, rust compiler and hikari OLLVM
WORKDIR /repos

RUN git clone --single-branch --branch 1.70.0 --depth 1 https://github.com/rust-lang/rust rust-1.70.0
RUN git clone --single-branch --branch rustc/16.0-2023-03-06 --depth 1 https://github.com/rust-lang/llvm-project llvm-16.0-2023-03-06
#RUN git clone --single-branch --branch llvm-16.0.0rel --recursive --depth 1 https://github.com/61bcdefg/Hikari-LLVM15 ollvm-16.0
COPY ollvm16.patch /repos/ollvm16.patch

# apply the OLLVM patch to LLVM to add obfuscation passes 
WORKDIR /repos/llvm-16.0-2023-03-06/
RUN git apply --reject --ignore-whitespace ../ollvm16.patch
RUN find . -name "*.rej"

# build custom LLVM
RUN mkdir build 
WORKDIR /repos/llvm-16.0-2023-03-06/build/
RUN cmake -G "Ninja" ../llvm -DCMAKE_INSTALL_PREFIX="./llvm_x64" -DCMAKE_CXX_STANDARD=17 -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;lld;" -DLLVM_TARGETS_TO_BUILD="X86" -DBUILD_SHARED_LIBS=ON -DLLVM_INSTALL_UTILS=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_BACKTRACES=OFF -DLLVM_BUILD_DOCS=OFF  -DBUILD_SHARED_LIBS=OFF

RUN cmake --build . -j8
RUN cmake --install .


# check if llvm was built
RUN /repos/llvm-16.0-2023-03-06/build/bin/llvm-config --version


# config rust compiler
WORKDIR /repos/rust-1.70.0/
RUN cp config.example.toml config.toml

RUN sed -i 's/#debug = false/debug = false/' config.toml
RUN sed -i 's/#channel = "dev"/channel = "nightly"/' config.toml
RUN sed -i 's/#llvm-config = <none> (path)/llvm-config = "\/repos\/llvm-16.0-2023-03-06\/build\/bin\/llvm-config"/' config.toml
RUN sed -i 's/#target = build.host (list of triples)/target = ["x86_64-unknown-linux-gnu", "x86_64-pc-windows-gnu"]/' config.toml


# build rust compiler
RUN python3 x.py build 
RUN python3 x.py build --target x86_64-pc-windows-gnu

# build cargo
#RUN python3 x.py build tools/cargo


# check toolchains
RUN rustup toolchain list --verbose


# rustup to configure nightly and install
WORKDIR /repos/
COPY rustup.sh /repos/rustup.sh
RUN chmod +x rustup.sh
RUN bash rustup.sh


# rustup link our custom OLLVM toolchain, make it default
RUN rustup toolchain link ollvm-rust-1.70.0 /repos/rust-1.70.0/build/x86_64-unknown-linux-gnu/stage1/
RUN rustup default ollvm-rust-1.70.0 


# Example compilation flags, use volumes to pass cargo packages into container
#
# docker run -v /my/cargo/proj/:/projects/ -it rustc-ollvm:latest /bin/bash
#
# cargo rustc --release -- -Cllvm-args=-enable-allobf -Cdebuginfo=0 -Cstrip=symbols -Cpanic=abort -Copt-level=3
# cargo rustc --release -- -Cllvm-args=-enable-bcfobf -Cllvm-args=-enable-splitobf -Cllvm-args=-enable-fco -Cllvm-args=-enable-funcwra -Cdebuginfo=0 -Cstrip=symbols -Cpanic=abort -Copt-level=3
#
# original thread: https://bbs.kanxue.com/thread-274453.htm

WORKDIR /projects/



