{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nix-utils = {
      url = "github:ilkecan/nix-utils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    crate2nix = {
      url = "github:kolloch/crate2nix";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        inherit (pkgs) callPackage;
      in
      {
        packages = rec {
          page = callPackage ./nix/page.nix { inherit inputs; };
          default = page;
        };
      }
    );
}
