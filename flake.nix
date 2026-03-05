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
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.curl
          pkgs.unzip
          pkgs.typst
          pkgs.just
          mdq.packages.${system}.default
        ];

        TYPST_FONT_PATHS = "${pkgs.dejavu_fonts}/share/fonts";
      };
    };
}
