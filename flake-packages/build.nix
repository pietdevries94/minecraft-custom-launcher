{
  pkgs ? import <nixpkgs> {},
  npmbp,
  gitignoreSrc
}:

let
  inherit (builtins) fromJSON readFile;
  info = fromJSON (readFile ../package.json);

  pname = "minecraft-custom-launcher";
  version = info.version;

  tauri = import ./tauri.nix {inherit pkgs;};

  bp = pkgs.callPackage npmbp { };
  inherit (import gitignoreSrc { inherit (pkgs) lib; }) gitignoreSource;

  nodeModules = bp.mkNodeModules {
    inherit version pname;
    src = gitignoreSource ../.;
    packageOverrides = {};
  };
in
pkgs.stdenv.mkDerivation rec {
  inherit pname version;

  src = gitignoreSource ../.;

  buildInputs = with pkgs; [
    nodejs_latest
    tauri
    bash

    rustc
    cargo

    openssl
    pkgconfig
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    libsoup
    gtk3
    webkitgtk
    wget

    rustPlatform.cargoSetupHook
  ];

  cargoDeps = pkgs.rustPlatform.importCargoLock {
    lockFile = ../src-tauri/Cargo.lock;
  };
  cargoRoot = "src-tauri";

  configurePhase = ''
    cp --reflink=auto -r ${nodeModules}/node_modules ./node_modules
    chmod -R u+w ./node_modules
  '';

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ./src-tauri/target/release/minecraft-custom-launcher $out/bin/
  '';
}