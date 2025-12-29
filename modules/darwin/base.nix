{ self, pkgs, user, ... }:
{
  # Disable nix-darwin's Nix management for Determinate Systems compatibility
  nix.enable = false;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [];
  programs.zsh.enable = true;

  users.users.${user.username} = {
    name = user.username;
    home = user.homeDirectory;
    shell = pkgs.zsh;
  };
}
