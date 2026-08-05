{ self, inputs, ... }: {
  flake.nixosConfigurations.testbench = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.testbenchConfiguration
    ];
  };
}
