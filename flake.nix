{
  description = "Minecraft Custom Launcher";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.npmbp.url = "github:serokell/nix-npm-buildpackage";
  inputs.gitignoreSrc = {
    url = "github:hercules-ci/gitignore.nix";
    flake = false;
  };

  outputs = { self, nixpkgs, npmbp, gitignoreSrc }:
    let
      linux = "x86_64-linux";
      pkgs = import nixpkgs {
        system = linux;
      };

      mcl = import ./flake-packages/build.nix {
        inherit pkgs npmbp gitignoreSrc;
      };

      mcl_app = {
        type = "app";
        program = "${mcl}/bin/minecraft-custom-launcher";
      };
    in
    {
      devShell."${linux}" = import ./shell.nix { inherit pkgs; };
      packages."${linux}".minecraft-custom-launcher = mcl;
      apps."${linux}".minecraft-custom-launcher = mcl_app;
      defaultPackage."${linux}" = mcl;
    };
}
