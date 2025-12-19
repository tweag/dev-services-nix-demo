{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  virtualisation.graphics = false;

  networking.firewall.enable = false;

  programs.bash.shellInit = ''
    bind -x '"\C-k": poweroff'
  '';

  services.getty.autologinUser = "root";

  system.stateVersion = "26.05";
}
