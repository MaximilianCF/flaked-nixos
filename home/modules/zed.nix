{ pkgs, ... }:

{

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extensions = [
      "swift"
      "nix"
      "xy-zed"
    ];
    extraPackages = [
      pkgs.nixd
    ];
    userSettings = {
      base_keymap = "VSCode";
      vim_mode = true;

      theme = "JetBrains New UI Theme";
      icon_theme = "Zed Icons";
      buffer_font_family = "JetBrains Mono";
      ui_font_size = 13;
      soft_wrap = "none";
      preferred_line_length = 100;
      highlight_active_line = true;

      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      restore_on_startup = "last_session";
      trim_trailing_whitespace_on_save = true;
      insert_final_newline_on_save = true;

      terminal = {
        detect_venv = {
          on = {
            directories = [
              ".venv"
              "venv"
            ];
          };
        };
        copy_on_select = true;
        working_directory = "current_project_directory";
      };

      formatter = "language_server";
      format_on_save = "on";
      inlay_hints = "on";

      lsp = {
        pyright = {
          settings = {
            "python.analysis" = {
              diagnosticMode = "workspace";
              typeCheckingMode = "strict";
            };
            python = {
              pythonPath = ".venv/bin/python";
            };
          };
        };
        nixd = {
          settings = {
            diagnostic = {
              suppress = [ "sema-extra-with" ];
            };
          };
        };
        terraform-ls = {
          initialization_options = {
            experimentalFeatures = {
              prefillRequiredFields = true;
            };
          };
        };
      };

      languages = {
        Python = {
          tab_size = 4;
          formatter = "language_server";
        };
        Nix = {
          tab_size = 2;
          preferred_line_length = 100;
        };
        Terraform = {
          tab_size = 2;
        };
      };
    };
  };
}
