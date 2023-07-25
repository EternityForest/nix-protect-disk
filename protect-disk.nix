{ pkgs, config, ... }:


let
helper = (pkgs.stdenv.mkDerivation {
  name = "protect-disk-helper";
  src = ./src;

  installPhase = ''
    # $out is an automatically generated filepath by nix,
    # but it's up to you to make it what you need. We'll create a directory at
    # that filepath, then copy our sources into it.
    mkdir $out
    cp -rv $src/* $out
    chmod 555 $out/bin/protect-disk-helper.sh
  '';

  nativeBuildInputs = [ pkgs.makeWrapper ];

  propagatedBuildInputs = with pkgs; [
    coreutils
    util-linux
  ];

  postFixup = ''
  wrapProgram $out/bin/protect-disk-helper.sh \
    --set PATH ${pkgs.lib.makeBinPath (with pkgs; [
      coreutils
      util-linux
    ])}
'';
});
in
{

systemd.services.protect-disk-helper = {
      wantedBy = [ "multi-user.target" ]; 
      before = [ "network.target" "graphical.target" "pipewire.service" ];
      description = "Helpers that protect the disk from excess writes";
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${helper}/bin/protect-disk-helper.sh";
      };
   };


environment.systemPackages= [
helper
];

fileSystems."/tmp" = {
  fsType = "tmpfs";
  device = "tmpfs";
  options = [ "nosuid" "nodev" "relatime"  "mode=1755" "size=1G" ];
};

fileSystems."/var/log" = {
  fsType = "tmpfs";
  device = "tmpfs";
  options = [ "nosuid" "nodev" "relatime" "mode=0755" "size=128M" ];
};

fileSystems."/var/lib/logrotate" = {
  fsType = "tmpfs";
  device = "tmpfs";
  options = [ "nosuid" "nodev" "relatime" "mode=0755" "size=8M" ];
};

fileSystems."/var/lib/NetworkManager" = {
  fsType = "tmpfs";
  device = "tmpfs";
  options = [ "nosuid" "nodev" "relatime" "mode=0755" "size=8M" ];
};

fileSystems."/var/lib/upower" = {
  fsType = "tmpfs";
  device = "tmpfs";
  options = [ "nosuid" "nodev" "relatime" "mode=0755" "size=8M" ];
};


}
