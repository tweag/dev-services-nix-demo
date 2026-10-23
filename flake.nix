{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system nixpkgs.legacyPackages.${system});
      inherit (import ./vm-helper.nix { inherit (nixpkgs) lib; }) nixosVM;
    in
    {
      packages = forAllSystems (
        system: pkgs: {
          default = nixosVM {
            hostPkgs = pkgs;
            modules = [
              ./dev-vm.nix
              ./production.nix
              ./local.nix
            ];
          };
        }
      );

      devShells = forAllSystems (
        system: pkgs: {
          default = pkgs.mkShell {
            PG_URI = "postgres://app-db@localhost/app-db";
            FERRET_URI = "mongodb://127.0.0.1:27017";
            packages = [
              (pkgs.writeShellApplication {
                name = "vm";
                text = "exec run-nixos-vm";
                runtimeInputs = [ self.packages.${system}.default ];
              })
              pkgs.postgresql
              pkgs.mongosh
            ];
          };
        }
      );
    };
}
