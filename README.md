# Obfuscator-LLVM-16.0



OLLVM 16.0 patch for Rust LLVM based on Hikari

- https://github.com/rust-lang/llvm-project/tree/rustc/16.0-2023-03-06
- Commit: 2b9c52f66815bb8d6ea74a4b26df3410602be9b0



To apply:


```
cd rust-llvm-16.0-2023-03-06
git apply --reject --ignore-whitespace ../ollvm16.patch
find . -name "*.rej" # If there is any rej file, then the conflict must be manually fixed
```




