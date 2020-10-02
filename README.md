# A bunch of nix packages

First install nix, with
```
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
```
Next, install cachix, with
```
nix-env -f '<nixpkgs>' -iA cachix
```

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
nix-env -iA gf-with-rgl -f https://github.com/anka-213/cclaw-nix-stuff/archive/master.tar.gz
nix-env -iA bnfc -f https://github.com/anka-213/cclaw-nix-stuff/archive/master.tar.gz
```

List of packages is in [default.nix](./default.nix)
