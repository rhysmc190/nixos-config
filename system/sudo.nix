{ config, ... }:
{
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=30
  '';

  # Shorten fingerprint timeout so SSH sudo falls through to password quickly
  security.pam.services.sudo.rules.auth.fprintd.args = [ "timeout=3" ];
}
