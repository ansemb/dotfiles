{ pkgs, ...}: {
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  # Packages
  home.packages = [ 
    pkgs.fish
    pkgs.zsh
    pkgs.exa
    pkgs.helix
    pkgs.zellij
    pkgs.lf
  ];


  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

