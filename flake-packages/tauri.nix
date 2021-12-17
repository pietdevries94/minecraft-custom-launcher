{ pkgs ? import <nixpkgs> {} }:

with pkgs;

rustPlatform.buildRustPackage rec {
  pname = "tauri-cli";
  version = "cli.rs-v1.0.0-beta.7";

  buildInputs = [] ++ (
    lib.optionals stdenv.isDarwin [
      gcc
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ]
  );

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    rev = version;
    sha256 = "K6zKIO96WjUb/T2cSP/e9fndrQq1iUku0tR4U+VL6NE=";
    fetchSubmodules = true;
  };
  sourceRoot = "source/tooling/cli.rs";
  cargoHash = "sha256-SX9E44iObpSlpJC+eqbCJs10z5X5ybtVCyw3wORZSqY=";
  postInstall = ''
  mv $out/bin/cargo-tauri $out/bin/tauri
  '';
}