{ inputs, ... }:
{
  pre-commit = {
    check.enable = true;

    settings = {
      hooks = {
        nixfmt-rfc-style = {
          enable = true;
        };

        convco = {
          enable = true;
        };

        terraform-format = {
          enable = true;
        };

        terraform-validate = {
          enable = false;
        };

        ensure-sops = {
          enable = false;
        };
      };
    };
  };
}
