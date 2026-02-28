{
  username,
  hostname,
  sshKeys,
  ...
}: {
  networking.hostName = hostname;

  # Set a password with 'passwd' after first boot
  users.users."${username}" = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [
      "wheel"
      "podman"
    ];
    openssh.authorizedKeys.keys = sshKeys;
  };

  nix.settings.trusted-users = [username];

  security.sudo.wheelNeedsPassword = false;
}
