{ pkgs ? import <nixpkgs> {} }:

let
  tauri = import ./flake-packages/tauri.nix {inherit pkgs;};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_latest
    tauri

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
  ];
}
