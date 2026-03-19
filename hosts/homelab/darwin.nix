{ lib, ... }:
{
  # Homelab-specific overrides
  security.pam.services = lib.mkForce { };
  environment.etc."pam.d/sudo_local".enable = lib.mkForce false;
}
