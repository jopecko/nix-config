# My NixOS configurations

Here's my NixOS/home-manager config files. Requires [Nix flakes](https://nixos.wiki/wiki/Flakes).

**Highlights**:

- Multiple **NixOS configurations**, including **desktop**, **laptop**, **server** [TODO]
- **Opt-in persistence** through impermanence + blank snapshotting
- **Encrypted** single **BTRFS** partition [TODO]
- Fully **declarative** **self-hosted** stuff
- Deployment **secrets** using **sops-nix** [TODO]
- Flexible **Home Manager** Configs through **feature flags**
- Extensively configured wayland environments (**hyprland**) and editor (**neovim**)
- **Declarative** **themes** and **wallpapers** with **nix-colors**

## Structure

- `flake.nix`: Entrypoint for hosts and home configurations. Also exposes a
  devshell for boostrapping (`nix develop` or `nix-shell`).
- `lib`: A few lib functions for making my flake cleaner
- `hosts`: NixOS Configurations, accessible via `nixos-rebuild --flake`.
  - `common`: Shared configurations consumed by the machine-specific ones.
    - `global`: Configurations that are globally applied to all my machines.
    - `optional`: Opt-in configurations my machines can use.
  - `ikaika`: Dell XPS 13 9310 - 32GB RAM, i7-1185G7 | Sway
  `home`: My Home-manager configuration, acessible via `home-manager --flake`
    - Each directory here is a "feature" each hm configuration can toggle, thus
      customizing my setup for each machine (be it a server, desktop, laptop,
      anything really).
- `modules`: A few actual modules (with options) I haven't upstreamed yet.
- `overlay`: Patches and version overrides for some packages. Accessible via
  `nix build`.
- `pkgs`: My custom packages. Also accessible via `nix build`. You can compose
  these into your own configuration by using my flake's overlay, or consume them through NUR.
- `templates`: A couple project templates for different languages. Accessible
  via `nix init`.


## About the installation

Home-manager is used in a standalone way, and because of opt-in persistence is
activated on every boot with `loginShellInit`.


## How to bootstrap

All you need is nix (any version). Run:
```
nix-shell
```

If you already have nix 2.4+, git, and have already enabled `flakes` and
`nix-command`, you can also use the non-legacy command:
```
nix develop
```

`nixos-rebuild --flake .` To build system configurations

`home-manager --flake .` To build user configurations

`nix build` (or shell or run) To build and use packages

`deploy` To easily deploy everything, both NixOS and home-manager profiles

`sops` To manage secrets


## Secrets [TODO]

For deployment secrets (such as user passwords and server service secrets), I'm
using the awesome [`sops-nix`](https://github.com/Mic92/sops-nix). All secrets
are encrypted with my personal PGP key (stored on a YubiKey), as well as the
relevant systems's SSH host keys.

On my desktop and laptop, I use `pass` for managing passwords, which are
encrypted using (you bet) my PGP key. This same key is also used for mail
signing, as well as for SSH'ing around.