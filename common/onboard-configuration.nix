# default.nix
# Provides a simple nix-os installation intended for bootstrapping the real install
{ config, lib, pkgs, ... }:
let
  admin-scripts = (pkgs.callPackage ../packages/admin-scripts {});
in
with lib; {

   # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8"; 
  # Setup a user account for onboarding
  users = {
    users.onboard = {
      isNormalUser = true;
      description = "Temporary user used to onboard nixos";
      group = "onboard";
      extraGroups = [ "networkmanager" "wheel" ];
      
      initialHashedPassword = "$y$j9T$ey8R7Bclqq3pWW477qgU//$xtVBLgFR5KsmRdM4pLfITdRnp2TdBDZ6I5T7Z4fnuE.";
      
      # Only use this key for onboarding
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQM3PinzEcWHWb7JZ+5iJMttHhlbIizZ4T9bcXvCD3f" ];

      packages = with pkgs; [
        admin-scripts  # Internal package
        tldr
      ];
    };
    groups.onboard = {};

    # Disable the root account login
    users.root = { initialHashedPassword = "!"; };
  };

  # Enable ssh, the onboard identity key will be needed
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false; 
}
