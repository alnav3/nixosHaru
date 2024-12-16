{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./../../modules/backup.nix
    ./../../modules/battery.nix
    ./../../modules/bluetooth.nix
    ./../../modules/desktop.nix
    ./../../modules/media.nix
    ./../../modules/networking.nix
    ./../../modules/ricing.nix
    ./../../modules/social.nix
    ./../../modules/steamos.nix
  ];

  # using latest linux kernel for network issues
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.amdgpu.initrd.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-jupiter-original"
      "steam-jupiter-unwrapped"
      "steamdeck-hw-theme"
    ];

  # Updating firmware | after first start we need to run fwupdmgr update
  services.fwupd.enable = true;


services.kanata = {
  enable = true;
  keyboards = {
    internalKeyboard = {
      devices = [
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
         caps
         n
        )
        (defalias
         caps (tap-hold 175 175 esc lctl)
         n (tap-hold 200 200 n (unicode ñ))
        )

        (deflayer base
         @caps
         @n
        )
      '';
    };
  };
};

networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 4200];
  };
}
