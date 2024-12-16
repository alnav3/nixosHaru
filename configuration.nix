{
  pkgs,
  meta,
  overlays,
  ...
}: {
    security.polkit.enable = true;
    # Add overlays
    nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      overlays.additions
    ];
  };
  imports =
    [./machines/${meta.hostname}/configuration.nix];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  services.openssh.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # user config
  users.users.haru = {
    isNormalUser = true;
    extraGroups = [
      "uinput"
      "wheel"
      "audio"
      "libvirtd"
    ];

    hashedPassword = "$6$aP7uDMQ8p8JtT21t$x45v1p1HOsnLt.logCloyTBWCGPIjekq8MSPMPWaYnUTTcy.k3ch8YsGni1j1EfSbi27S31YuinngXF3WmXfb/";
  };

  security.sudo.extraRules = [
    {
      users = ["haru"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    cifs-utils
    age
    killall
  ];

  system.stateVersion = "24.11";
}
