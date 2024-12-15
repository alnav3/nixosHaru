{pkgs, ...}: {
  services.netbird.enable = true;
  environment.systemPackages = with pkgs; [
    netbird-ui
  ];
  networking.networkmanager.enable = true;
  boot.kernelParams = ["ipv6.disable=1"];
}
