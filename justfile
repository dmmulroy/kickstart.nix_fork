clean-template template:
    rm -rf /tmp/kickstart.nix/{{ template }}
    mkdir -p /tmp/kickstart.nix/{{ template }}

build-darwin system="x86_64": (clean-template "darwin")
    #!/usr/bin/env bash
    DERIVATION=$(nix build --json --no-link --print-build-logs ".#example-darwin")
    OUTPUT=$(echo $DERIVATION | jq -r ".[0].outputs.out")
    cp -r $OUTPUT/* /tmp/kickstart.nix/darwin
    nix build --json --no-link --print-build-logs \
        "/tmp/kickstart.nix/darwin#darwinConfigurations.{{ system }}.config.system.build.toplevel"

build-home-manager system="x86_64-linux": (clean-template "home-manager")
    #!/usr/bin/env bash
    DERIVATION=$(nix build --json --no-link --print-build-logs ".#example-home-manager")
    OUTPUT=$(echo $DERIVATION | jq -r ".[0].outputs.out")
    cp -r $OUTPUT/* /tmp/kickstart.nix/home-manager
    nix build --json --no-link --print-build-logs \
        "/tmp/kickstart.nix/home-manager#homeConfigurations.{{ system }}.activationPackage"

build-language template profile="default": (clean-template template)
    #!/usr/bin/env bash
    DERIVATION=$(nix build --json --no-link --print-build-logs ".#example-{{ template }}")
    OUTPUT=$(echo $DERIVATION | jq -r ".[0].outputs.out")
    cp --no-preserve=mode -r $OUTPUT/* /tmp/kickstart.nix/{{ template }}
    nix build --json --no-link --print-build-logs "/tmp/kickstart.nix/{{ template }}#{{ profile }}"

build-nixos-desktop system="x86_64" desktop="gnome": (clean-template "nixos-desktop")
    #!/usr/bin/env bash
    DERIVATION=$(nix build --json --no-link --print-build-logs ".#example-nixos-desktop-{{ desktop }}")
    OUTPUT=$(echo $DERIVATION | jq -r ".[0].outputs.out")
    cp --no-preserve=mode -r $OUTPUT/* /tmp/kickstart.nix/nixos-desktop
    nix build --json --no-link --print-build-logs \
        "/tmp/kickstart.nix/nixos-desktop#nixosConfigurations.{{ system }}.config.system.build.toplevel"

build-nixos-minimal system="x86_64": (clean-template "nixos-minimal")
    #!/usr/bin/env bash
    DERIVATION=$(nix build --json --no-link --print-build-logs ".#example-nixos-minimal")
    OUTPUT=$(echo $DERIVATION | jq -r ".[0].outputs.out")
    cp --no-preserve=mode -r $OUTPUT/* /tmp/kickstart.nix/nixos-minimal
    nix build --json --no-link --print-build-logs \
        "/tmp/kickstart.nix/nixos-minimal#nixosConfigurations.{{ system }}.config.system.build.toplevel"
