# Protect-Disk

It's just a set of tmpfses on frequently
written things that really do not need to be
persistent.

Note that this assumes a single user at uid 1000, things like pipewire being too chatty with the state dir will not be stopped for other users.

Put this whole repo in your /etc/nixos, and then in your imports section add ./nix-protect-disk/protect-disk.nix