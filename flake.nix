{
  description = "lenovo NixOS configuration | WIP to be generic";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Unstable Packages
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    # Zen browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos hardware presets
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:danth/stylix";

    # deck experience on NixOS
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";

    dotfiles = {
      url = "github:adrestrod/dotfiles";
      flake = false;
    };

    tpm = {
      url = "github:tmux-plugins/tpm";
      flake = false;
    };

    rofi-wifi = {
      url = "github:zbaylin/rofi-wifi-menu";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    dotfiles,
    nixos-hardware,
    ...
  } @ inputs: let
    hosts = [
      {
        name = "lenovo";
        system = "x86_64-linux";
        useHomeManager = true;
      }


    ];
  in {
    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host.name;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {
            overlays = import ./overlays;
            inherit inputs dotfiles;
            meta = {hostname = host.name;};
            pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${host.system};
          };
          system = host.system;
          modules =
            [
              # disko
              disko.nixosModules.disko

              # System Specific
              ./machines/${host.name}/hardware-configuration.nix
              ./machines/${host.name}/disko-config.nix

              # General
              ./configuration.nix

              # home-manager
            ]
            ++ (
              if host.useHomeManager
              then [
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.haru = import ./home.nix;
                  home-manager.backupFileExtension = "bak";
                  home-manager.extraSpecialArgs = {
                    inherit inputs;
                    meta = host;
                  };
                }
              ]
              else []
            )
            ++ (
              if host.name == "lenovo"
              then [
                # Deck SteamOS experience
                inputs.jovian-nixos.nixosModules.jovian

                # Ricing the nixOS way
                inputs.stylix.nixosModules.stylix
                nixos-hardware.nixosModules.lenovo-13-7040-amd
              ]
              else []
            );
        };
      })
      hosts
      ++ [
        {
          name = "isoInstaller";
          value = nixpkgs.lib.nixosSystem {
            modules = [
              ./iso.nix
            ];
            specialArgs = {
              inherit inputs;
            };
          };
        }
      ]);
  };
}
