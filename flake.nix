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
    };
  };
}
