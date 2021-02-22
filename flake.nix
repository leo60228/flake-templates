{
  outputs = { ... }: {
    templates = {
      shell = {
        path = ./shell;
        description = "A simple devShell";
      };
    };
  };
}
