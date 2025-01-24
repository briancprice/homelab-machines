# Machine Hardware Configuration

## Machine Bootstrap Instructions

The bootstrap configuration for homelab machines is as follows...
homelab/machines contains a directory for each machine...
```sh
# Directory Structure
/homelab/machine/lenovo
/homelab/machines/lenovo/disko.nix

/homelab/machines/flake.nix
```
TODO: Finsish documentation
---

[NixOS Wiki: Disko](wiki.nixos.org/wiki/Disko)

### Common Machine Installation Process

#### Enable ssh on NixOS Install image...
```sh
# Run ip addr to get the ip
ip addr
# Set the user's password
passwd
# Set the root user's password
sudo passwd
# Restart sshd
sudo systemctl restart sshd
```

### Wipeout everything for fresh install
```sh
# WARNING: THIS WILL ERASE EVERYTHING
sudo wipefs --all /dev/vda
```

#### Install the boostsrap image...
```sh
# This example will use the Lenovo machine configuration...
#
# 1.  Boot the machine/vm with the NixOS installer
# 2.  Retrieve the git repository

cd ~/
git clone https://github.com/briancprice/homelab.git
cd homelab

# 3.  Run Disko to partition/format the drives
# *** WARNING this is destructive!
sudo nix --experimental-features "nix-command flakes" \
run github:nix-community/disko -- \
--mode disko ./machines/lenovo/disko.nix

# Notice that the command enables flakes and nix-command
# Look at all the output from disko and verify success

# 4.  Install the simple onboarding configuration for the        machine...

sudo nixos-install --flake ./machines#lenovo-bootstrap \
--no-root-password

# 5.  Reboot the machine and verify success.  The bootstrap profiles only have one user by default, this is root, you'll need to ssh into the machine using the key

# 6.  Perform any imparative configuration needed for the machine
#     - SOPS secrets for example

# 7.  Run the installer for the main machine host
# Notice this flake is in the homelab root directory
nixos-install --flakes ./#lenovo-host \
--no-root-passwd

```

```bash
# Note: disko-install can be used to format, partition, and install in one step

sudo nix --experimental-features "nix-command flakes" \
run github:nix-community/disko/latest#disko-install -- \
--write-efi-boot-entries \
--flake ./machines#lenovo-bootstrap \
--disk main /dev/vda

# Note:
# --write-efi-boot-entries is needed for non-removable drives
# --disk main /dev/vda replaces the main disk entry in the disko.nix

```

## Resources

### ZFS
- [NixOS - Wiki - ZFS](https://nixos.wiki/wiki/ZFS)
- [ZFS - Tuning Cheat sheet](https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet)

### Disko
- [NixOS - Wiki - Disko](https://nixos.wiki/wiki/disko)
- [Github:Disko](https://github.com/nix-community/disko)
- TIP: Search GitHub using path:disko.nix e.g. zfs path:disko.nix

### Ephemeral Support
- [Impermanence Module](https://github.com/nix-community/impermanence): A module to map directories to permanent store.
- [tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root): How to configure system for impermanence.
- [tmpfs as home](https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/):Use impermanence module with home-manager
- [Erase Your Darlings](https://grahamc.com/blog/erase-your-darlings/): Essay on "why" you should create an ephemeral system


*See the readme in the root of this project for more information.*