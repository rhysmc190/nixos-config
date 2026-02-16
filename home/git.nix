{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "rhysmc190";
        email = "rhysmc190@gmail.com";
      };
      alias = {
        ac = "!git add -A && git commit -m";
      };
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
      push = { autoSetupRemote = true; };
    };
  };
}
