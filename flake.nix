{
  description = "Schulprojekt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    mdq = {
      url = "git+https://git.hydrar.de/mdtools/mdq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, mdq }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.curl
          pkgs.unzip
          pkgs.typst
          pkgs.just
#          mdq.packages.${system}.default
        ];

        TYPST_FONT_PATHS = builtins.concatStringsSep ":" [
          "${pkgs.inter}/share/fonts"
          "${pkgs.source-sans}/share/fonts"
          "${pkgs.ibm-plex}/share/fonts"
          "${pkgs.corefonts}/share/fonts/truetype"
        ];
      };
    };
}
