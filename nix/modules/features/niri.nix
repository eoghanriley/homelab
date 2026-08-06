{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = {
        extraConfig = ''
          prefer-no-csd
        '';

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard = {
          xkb.layout = "us";
        };

        layout.gaps = 5;

        binds = {
	      # Launch applications
          "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;

	      # Manage windows
          "Mod+W".close-window = {};
	      "Mod+MouseMiddle".close-window = {};

	      "Mod+F".fullscreen-window = {};

	      "Mod+minus".set-column-width = "-10%";
	      "Mod+equal".set-column-width = "+10%";
	      "Mod+Shift+minus".set-window-height = "-10%";
	      "Mod+Shift+equal".set-window-height = "+10%";

	      # Movement
	      "Mod+bracketleft".focus-column-left = {};
	      "Mod+bracketright".focus-column-right = {};
	      "Mod+braceleft".focus-window-up = {};
	      "Mod+braceright".focus-window-down = {};

	      "Mod+Left".move-column-left = {};
	      "Mod+Right".move-column-right = {};
	      "Mod+Up".move-window-up = {};
	      "Mod+Down".move-window-down = {};
          
	      # Util
	      "Mod+Shift+S".screenshot = {};
	      "Mod+Shift+W".screenshot-window = {};

	      "Mod+Space".toggle-overview = {};

          spawn-at-startup = [
	        (lib.getExe self'.packages.myNoctalia)
	      ];
          "Alt+Space".spawn-sh =
	       "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
        };
      };
    };
  };
}
