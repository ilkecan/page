{
  callPackage,
  crate2nix ? inputs.crate2nix,
  inputs,
  lib,
  nix-filter ? inputs.nix-filter.lib,
  nix-utils ? inputs.nix-utils.lib,
}:

let
  inherit (nix-filter) inDirectory;
  inherit (nix-utils) sourceOf;

  root = inputs.self;
  cargoToml = lib.importTOML "${root}/Cargo.toml";
  inherit (cargoToml.package) name;

  crateTools = callPackage "${sourceOf crate2nix}/tools.nix" { };
  buildRustCrateForPkgs = pkgs: with pkgs; buildRustCrate;
  cargoNix = callPackage (crateTools.generatedCargoNix {
    inherit name;
    src = nix-filter {
      inherit name root;
      include = [
        "Cargo.lock"
        "Cargo.toml"
        (inDirectory "src")
      ];
    };
  }) { inherit buildRustCrateForPkgs; };
in

cargoNix.rootCrate.build
