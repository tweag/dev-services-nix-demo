{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      inherit (import ./vm-helper.nix { inherit (nixpkgs) lib; }) nixosVM;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = nixosVM {
        modules = [
          ./dev-vm.nix
          ./production.nix
          ./local.nix
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
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
    };
}
