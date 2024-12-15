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

    hashedPassword = "$6$Ld6VVI/GPx3tS3HO$pAjCdjWroN88QoCPCER7UdXq1XTbC1C8linCar7/ykEsgtya4JesK1ILX5ffoRqgMkTR/NPN10NfYsvI2yHzE.";
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
