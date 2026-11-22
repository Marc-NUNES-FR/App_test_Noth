# App_test_Noth

Application de test pour Nothing Watch Pro 2 utilisant cmf-watch-sdk.

Cette application affiche simplement le texte "ceci est un test" au centre de l'écran.

## Structure du projet

- `Cargo.toml` : Workspace Cargo
- `app/` : Source de l'application
  - `Cargo.toml` : Configuration du crate
  - `src/main.rs` : Code principal
- `cmf-watch-sdk/` : SDK cloné (sous-dossier)
- `build.sh` : Script de build

## Prérequis

- Rust (avec la cible `thumbv7em-none-eabi`)
- llvm-tools-preview (pour llvm-objcopy)
- Python avec wp2apps (pour créer le .wp2app)

## Installation des dépendances

```bash
# Installer la cible ARM
rustup target add thumbv7em-none-eabi

# Installer llvm-tools
rustup component add llvm-tools-preview
```

## Build

```bash
# Compiler l'application
cargo build --release --target thumbv7em-none-eabi -p app_test_noth

# Ou utiliser le script
./build.sh
```

## Création du fichier .wp2app

Si vous avez wp2apps installé :

```bash
wp2apps pack target/app_test_noth.bin \
    --elf target/thumbv7em-none-eabi/release/app_test_noth \
    --name "Test App" \
    --version 1 \
    --output target/app_test_noth.wp2app
```

## Installation sur la montre

Voir la documentation du SDK : https://github.com/InukaAsith/cmf-watch-sdk/blob/main/docs/app-guide.md
