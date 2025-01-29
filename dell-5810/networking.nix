{ config, lib, pkgs, namespace, ... }: 
let cfg = config.${namespace}.homelab.machines; in
{
  config.${namespace}.homelab.machines.networking = {
    hostIdSeed = "dell-5810";
    defaultNetworkingConfig = "static-bridge";
    primaryNetworkInterface = "enp0s25";
    primaryNetworkBridge = "br0";
    disableIPV6 = true;
  };
  
  config.networking.interfaces.${cfg.networking.primaryNetworkBridge} = {
    ipv4.addresses = [
      {
        address = "192.168.50.10";
        prefixLength = 24;
      }];
  };
  

  config.networking.defaultGateway = "192.168.50.1";
  config.networking.nameservers = [ "192.168.50.1" ];
}