{pkgs, pkgs-stable, ...}: {
  environment.systemPackages = with pkgs; [
    vesktop
    telegram-desktop
    element-desktop
  ]
  ++
  [pkgs-stable._64gram];

}
