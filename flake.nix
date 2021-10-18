{
  outputs = { ... }: {
    templates = {
      shell = {
        path = ./shell;
        description = "A simple devShell";
      };

      pcb = {
        path = ./pcb;
        description = "A KiCAD project";
      };

      package = {
        path = ./package;
        description = "A simple package";
      };

      rp2040 = {
        path = ./rp2040;
        description = "A pico-sdk project";
      };
    };
  };
}
