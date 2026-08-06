{ self, inputs, ... }: {
 flake.nixosModules.emacs = { pkgs, lib, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myEmacs
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.myEmacs = 
     (pkgs.extend inputs.nix-doom-emacs-unstraightened.overlays.default).emacsWithDoom {
      doomDir = "${./.}";
      doomLocalDir = "~/.local/share/nix-doom";
    };
  };
}
