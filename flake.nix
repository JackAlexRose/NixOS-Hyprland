{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    catppuccin.url = "github:catppuccin/nix";
    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    yazi.url = "github:sxyazi/yazi";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    alejandra,
    ghostty,
    yazi,
    ...
  } @ inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        {
          environment.systemPackages = [
            alejandra.defaultPackage.${system}
            pkgs.code-cursor
            ghostty.packages.${system}.default
            yazi.packages.${system}.default
            ];
        }
        ./configuration.nix
        inputs.catppuccin.nixosModules.catppuccin
      ];
    };
  };
}
