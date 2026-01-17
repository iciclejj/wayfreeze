{
  description = "Tool to freeze the screen of a Wayland compositor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, systems, ... }:
    let
      forAllSystems =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustfmt
            cargo
            libxkbcommon
          ];
        };
      });
      packages = forAllSystems (pkgs: rec {
        default = wayfreeze;
        wayfreeze = pkgs.rustPlatform.buildRustPackage {
          name = "wayfreeze";
          src = ./.;
          cargoHash = "sha256-uzTT4WyR7kCL/HPu7JHGQqG9tbO1JGIW1Jtlza5lhPk=";
          doCheck = true;
          nativeBuildInputs = [ ];
          buildInputs = with pkgs; [ libxkbcommon ];
        };
      });
    };
}
