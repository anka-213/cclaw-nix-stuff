# A bunch of nix packages

Everything is prebuilt on both macos and linux. To use precompiled packages:
```
cachix use cclaw
```

Install everything with

```
nix-env -if https://github.com/anka-213/cclaw-nix-stuff/archive/master.tar.gz
```

Install a single package with for example

```
nix-env -iA gf-rgl -f https://github.com/anka-213/cclaw-nix-stuff/archive/master.tar.gz
```

List of packages is in [default.nix](./default.nix)
