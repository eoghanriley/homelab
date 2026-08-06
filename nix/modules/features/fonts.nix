{ self, inputs, ... }: {
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      (pkgs.callPackage "${pkgs.path}/pkgs/data/fonts/gdouros" { }).symbola
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
