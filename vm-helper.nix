{ lib, ... }:
{
  # The guest is always x86_64-linux. The generated launcher script is built
  # for `hostPkgs.stdenv.hostPlatform.system` (e.g. x86_64-linux, aarch64-darwin).
  nixosVM =
    {
      hostPkgs,
      modules,
    }:
    (lib.nixosSystem {
      system = "x86_64-linux";
      modules = modules ++ [ { virtualisation.host.pkgs = hostPkgs; } ];
    }).config.system.build.vm;
}
