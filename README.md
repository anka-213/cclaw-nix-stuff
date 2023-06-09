# A bunch of nix packages, primarily for Grammatical Framework

Nix expressions for a bunch of [Grammatical Framework](https://grammaticalframework.org/) stuff.
They are built in ci and cached on the `cclaw` cachix account.

## Installing nix

First install nix, with
```
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
```

Load the new environment with
```
. ~/.nix-profile/etc/profile.d/nix.sh
```

Next, install cachix, with
```
nix-env -f '<nixpkgs>' -iA cachix
```

## Using the cache

Everything is prebuilt on both macos and linux. To use precompiled packages:
```
sudo cachix use cclaw
```

## Installing the packages

The included packages (can be seen in [flake.nix](./flake.nix)) are:

- bnfc (latest version from git)
- gf-core - just the gf binary without rgl
- gf-rgl - the rgl library
- gf-wordnet - the wordnet library
- gf-with-rgl - gf with rgl in GF_LIB_PATH
- gf-with-rgl-and-wordnet
- gf-python-runtime - the python pgf library (see below for instructions)


In order to use the separate rgl and wordnet from nix, set GF_LIB_PATH to

```bash
export GF_LIB_PATH=$HOME/.nix-profile/share/gf/lib
```

otherwise just use `gf-with-rgl` or `gf-with-rgl-and-wordnet` which comes with the GF_LIB_PATH preconfigured

Install a package with for example

```bash
nix profile install github:anka-213/cclaw-nix-stuff/nix-flakes#gf-with-rgl
nix profile install github:anka-213/cclaw-nix-stuff/nix-flakes#gf-with-rgl-and-wordnet
```

or check what would be installed using

```
nix build --dry-run github:anka-213/cclaw-nix-stuff/nix-flakes#gf-with-rgl
nix build --dry-run github:anka-213/cclaw-nix-stuff/nix-flakes#gf-with-rgl-and-wordnet
```

## Using python or haskell with runtimes installed

In order to get an ad-hoc environment with the python runtime or haskell runtime installed, you can use the following:

Python:
 ```bash
 nix shell \
     --impure \
     --expr "with builtins; with getFlake "github:anka-213/cclaw-nix-stuff/nix-flakes"; (getAttr currentSystem legacyPackages).python3.withPackages (ps: with ps; [ gf-pgf gnureadline ])"
 ```

 Haskell:
 ```bash
 nix shell \
     --impure \
     --expr "with builtins; with getFlake "github:anka-213/cclaw-nix-stuff/nix-flakes"; (getAttr currentSystem legacyPackages).haskellPackages.ghcWithPackages (ps: with ps; [ gf-core gf-c-bindings ])"
 ```

You could also put the corresponding code in a nix-file to get a more permanent environment.
