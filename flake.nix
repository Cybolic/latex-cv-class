{
  description = "CV LaTeX Document";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    vale-nix = {
      url = "github:icewind1991/vale-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yaml.url = "github:jim3692/yaml.nix";
  };
  outputs = { self, nixpkgs, flake-utils, vale-nix, yaml }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      overlays = [ vale-nix.overlays.default ];
      pkgs = (import nixpkgs) { inherit system overlays; };
      valeLint = (pkgs.valeWithConfig (let
        lib = pkgs.lib;
        resume = yaml.lib.fromYaml ./resume.yaml;
        separateString = s: (
          lib.strings.splitString " " (builtins.replaceStrings ["/" ","] ["" ""] s)
        );
      in {
        packages = styles: with styles; [proselint readability];
        vocab = { accept = (
          # Add all names to vocab
          (lib.strings.splitString " " resume.basics.name)
          ++ (lib.lists.flatten (
            map (r: lib.strings.splitString " " r.name) resume.references)
          )
          ++ (map (p: p.username) resume.basics.profiles)
          # Add all netkork names (LinkedIn, GitHub, etc) to vocab
          ++ (map (p: p.network) resume.basics.profiles)
          # Add all company names to vocab
          ++ (lib.lists.flatten (map (w: separateString w.name) resume.work))
          # Add all keywrd names (usually names of tech) to vocab
          ++ (lib.lists.flatten (map (w: map (k: separateString k) w.keywords) resume.work))
          ++ (lib.lists.flatten (map (s: map (k: separateString k) s.keywords) resume.skills))
          ++ [
            "personalSummary"
            "startDate"
            "endDate"
            "bulletpoints"

            "calc" "flexbox" "polyfill" "polyfills"
            "components" "pipelines"
            "fullstack" "Fullstack"
            "customisable"
            "demoable"
            "devshell"
          ]
        ); };
        formatOptions = {
          "*" = {
            basedOnStyles = ["Vale" "proselint" "Readability"];
          };
        };
      }));

      inputResume = "resume.yaml";
      inputFilename = ./main.tex;
      outputFilename = "cv.pdf";
      # pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-basic latex-bin latexmk luatex
        xcolor geometry eqparbox environ etoolbox microtype luacode luatexbase
        paralist enumitem hyperref 
        tabularray multirow makecell tcolorbox
        markdown gobble
        pgf xifthen csvsimple
        fancyhdr fancyvrb titlesec fontspec nunito fontawesome5;
      };
      texSetupEnv = /* bash */ ''
        DIR=$(mktemp -d)
        mkdir -p "$DIR/.texcache/texmf-var"
        mkdir -p "$DIR/.home" # a clean home is needed for the font cache
      '';
      texEnv = /* bash */ ''
        env \
          HOME="$DIR/.home" \
          TEXMFHOME="$DIR/.texcache/home" \
          TEXMFVAR="$DIR/.cache/texmf-var" \
          OSFONTDIR=${pkgs.fira-mono}/share/fonts'';
      latexmkCmd = {
        name ? "",
        previewer ? "",
        copyOutput ? true,
        inputYaml ? inputResume,
        inputTex ? inputFilename,
        outputPdf ? outputFilename
      }: pkgs.writeShellApplication {
        name = if name != "" then name else (if previewer == "" then "latex-cv-build" else "latex-cv-preview");
        runtimeInputs = [ pkgs.coreutils pkgs.gnused pkgs.fira-mono tex ];
        text = /* bash */ ''
          INPUT_YAML="${inputYaml}"
          INPUT_TEX="${inputTex}"
          ${ if copyOutput then
            ''OUTPUT_PDF="${outputPdf}"''
          else "" }
          ${texSetupEnv}
          echo -e "Compiling pdf from:\n\tyaml: $INPUT_YAML\n\ttex: $INPUT_TEX"
          sed "s|resume-example.yaml|$INPUT_YAML|g" "$INPUT_TEX" > "$DIR/input.tex"
          ${texEnv} \
            latexmk -interaction=nonstopmode -pdf -lualatex \
            -output-directory="$DIR" \
            -norc \
            ${
              if previewer == "" then
                ''-f "$DIR/input.tex"''
              else (/* bash */ '' \
                -e "\$pdf_previewer = 'start ${previewer}';" \
                -e "@default_files = ('$DIR/input.tex');" \
                -e "set_tex_cmds( '--interaction=batchmode %O %S' );" \
                -pvc -time \
                <(cat "$INPUT_TEX" | sed "s|resume-example.yaml|${INPUT_YAML}|g")
              '')
            }
          ${ if copyOutput then
            ''cp "$DIR/input.pdf" "$OUTPUT_PDF"'' else "" }
          rm -rf "$DIR"
        '';
      };
      cvBaseDerivationOptions = {
        copyOutput = true;
        inputYaml = "$1";
        inputTex = "$2";
        outputPdf = "$3";
      };
      cvBaseDerivationScript = commandName: /* bash */ ''
        INPUT_RESUME="''${1:-"${inputResume}"}"
        INPUT_TEX="''${2:-"${inputFilename}"}"
        OUTPUT_PDF="''${3:-"${outputFilename}"}"
        ${commandName} "$INPUT_RESUME" "$INPUT_TEX" "$OUTPUT_PDF"
      '';
      cvBuilder = pkgs.writeShellApplication {
        name = "latex-cv-build";
        runtimeInputs = [ (
          latexmkCmd ({
            name = "latex-cv-build";
          } // cvBaseDerivationOptions)
        ) ];
        text = cvBaseDerivationScript "latex-cv-build";
      };
      cvPreviewer = pkgs.writeShellApplication {
        name = "latex-cv-preview";
        runtimeInputs = [ (
          latexmkCmd ({
            name = "latex-cv-preview";
            previewer = "${pkgs.zathura}/bin/zathura";
          } // cvBaseDerivationOptions)
        ) ];
        text = cvBaseDerivationScript "latex-cv-preview";
      };

    in rec {
      devShells = {
        # Unified shell environment
        default = pkgs.mkShell
          {
            buildInputs = [
              cvBuilder
              cvPreviewer
              valeLint
            ];
          };
      };
      packages = {
        lint = pkgs.writeShellApplication {
          name = "lintYaml";
          runtimeInputs = [ pkgs.gnused pkgs.yq valeLint ];
            # vale --output=JSON <(yq '${pkgs.lib.strings.concatStringsSep " | " [
          text = /* bash */ ''
            INPUT_RESUME="''${1:-"resume.yaml"}"
            exec \
              vale <(yq '${pkgs.lib.strings.concatStringsSep " | " [
                ''{basics, work, projects}''
                ''with_entries(select(.value != null))''
                ''del(..  | .url?, .email?, .username?, .keywords?)''
                ''del( .basics.profiles )''
              ]}' "$INPUT_RESUME" | sed "s/\bol’ /old /g")
          '';
        };

        document = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-cv-document";
          src = self;
          buildInputs = [ pkgs.coreutils (
            latexmkCmd { name = "latex-cv-build"; copyOutput = true; }
          ) ];
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          buildPhase = /* bash */ ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            latex-cv-build
          '';
          installPhase = ''
            mkdir -p $out
            cp ${outputFilename} $out/
          '';
        };
        
        build = cvBuilder;

        preview = cvPreviewer;

        yamlToPdf = { inputYaml }:
          pkgs.stdenvNoCC.mkDerivation (let
            buildInputs = [ pkgs.coreutils cvBuilder ];
          in {
            name = "yaml-to-pdf";
            src = self;
            inherit buildInputs;

            phases = ["unpackPhase" "buildPhase" "installPhase"];

            buildPhase = ''
              export PATH="${pkgs.lib.makeBinPath buildInputs}";
              mkdir -p $out
              latex-cv-build "${inputYaml}" "${inputFilename}" cv.pdf
            '';

            installPhase = ''
              cp cv.pdf $out/
            '';
          });
      };
      defaultPackage = packages.document;
    });
}
