# flake.nix NixOS machine hardware configurations for my home lab
{
  description = "NixOS machine hardware configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:/nix-community/impermanence";
  };

  outputs = { self, nixpkgs, disko, impermanence, ... }@inputs:
  let
      namespace = "github__briancprice.homelab";
      stateVersion = "24.11"; 
      system-x86_64-linux = "x86_64-linux";

      pkgs = import nixpkgs { system = system-x86_64-linux; };

  in {

    packages.${system-x86_64-linux} = {
      admin-scripts = pkgs.callPackage ./packages/admin-scripts {};
    };

    # These NixOs system configurations can be
    # used to bootstrap a base config after
    # installing disko to setup requirements
    # prior to installing the final
    # host configurations from the main flakes
    nixosModules = {
      qemuConfig = { config, lib, ... }: {
        imports = [
          inputs.disko.nixosModules.disko
          ./common
          ./qemu/machine-configuration.nix
        ];
      };

      lenovoConfig = { config, ... }: {
        imports = [
          inputs.disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
          ./common
          ./lenovo/machine-configuration.nix
        ];
      };

      dell-5810Config = { config, pkgs, ...}: {
        imports = [
          inputs.disko.nixosModules.disko
          ./common
          ./dell-5810
        ];
        
      };
    };

    nixosConfigurations = {

      # Base configuration for my lenovo laptop
      lenovo-bootstrap = nixpkgs.lib.nixosSystem {
        system = system-x86_64-linux;
        specialArgs = { namespace = namespace; };
        modules = [
          ({ ... }: { system.stateVersion = stateVersion; })
          self.nixosModules.lenovoConfig
          ./common/onboard-configuration.nix
        ];
      };

      # Base configuration for a qemu vm
      qemu-guest-bootstrap = nixpkgs.lib.nixosSystem {
        system = system-x86_64-linux;
        specialArgs = { namespace = namespace; };
        modules = [
          ({ ... }: { system.stateVersion = stateVersion; })
          self.nixosModules.qemuConfig
          ./common/onboard-configuration.nix
        ];
      };

       # Base configuration for a qemu vm
      dell-5810-bootstrap = nixpkgs.lib.nixosSystem {
        system = system-x86_64-linux;
        specialArgs = { namespace = namespace; };
        modules = [
          ({ ... }: { system.stateVersion = stateVersion; })
          self.nixosModules.dell-5810Config
          ./common/onboard-configuration.nix
        ];
      };

    };

  };
}
