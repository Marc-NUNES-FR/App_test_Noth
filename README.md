# App_test_Noth

**Repository pour créer plusieurs applications pour Nothing Watch Pro 2** utilisant [cmf-watch-sdk](https://github.com/InukaAsith/cmf-watch-sdk).

## 📁 Structure du projet

```
App_test_Noth/
├── .github/workflows/    # Workflows GitHub Actions
├── apps/                # Toutes les applications
│   ├── test_app/        # App 1 : "ceci est un test"
│   │   ├── Cargo.toml
│   │   ├── src/main.rs
│   │   └── icon.svg
│   └── ...              # Ajoutez vos autres apps ici
├── build.sh             # Build une app spécifique
├── build-all.sh         # Build toutes les apps
├── Cargo.toml           # Workspace Rust
└── cmf-watch-sdk/       # SDK (sous-module git)
```

## 🚀 Utilisation

### Prérequis
```bash
# Installer la cible ARM
rustup target add thumbv7em-none-eabi
rustup component add llvm-tools-preview

# Pour générer les .wp2app (optionnel)
pip install -e cmf-watch-sdk/
```

### Builder une app
```bash
# Builder une app spécifique
./build.sh test_app

# Builder toutes les apps
./build-all.sh
```

### Fichiers générés
| Fichier | Utilisation |
|---------|-------------|
| `target/test_app.bin` | Émulateur web (cmf.arnv.dev) |
| `target/test_app.wp2app` | Installation sur la vraie montre |

## 📱 Ajouter une nouvelle app

1. **Créer le dossier** :
```bash
mkdir -p apps/ma_nouvelle_app/src
```

2. **Copier les fichiers de base** :
```bash
cp apps/test_app/Cargo.toml apps/ma_nouvelle_app/
cp apps/test_app/icon.svg apps/ma_nouvelle_app/
```

3. **Modifier le code** :
Éditez `apps/ma_nouvelle_app/src/main.rs` avec votre logique.

4. **Builder** :
```bash
./build.sh ma_nouvelle_app
```

## 🌐 Tester sur l'émulateur

1. Récupérez le fichier `.bin` :
```bash
ls target/*.bin
```

2. Upload sur [https://cmf.arnv.dev/emulator/watch-pro-2/](https://cmf.arnv.dev/emulator/watch-pro-2/?firmware=kqbnulphohzw2wb)

## 📲 Installer sur la vraie montre

```bash
# Installer via BLE
wp2apps install target/test_app.wp2app --address <UUID>

# Trouver l'adresse de la montre
wp2apps scan --show-address
```

## 🔄 GitHub Actions

À chaque push, le workflow build toutes les apps et génère les fichiers `.bin` en artifacts.

- **Voir les builds** : Onglet "Actions" → Télécharger les artifacts
- **Fichiers générés** : `target/*.bin` pour chaque app

## 📝 Exemple : test_app

L'app `test_app` incluse affiche simplement "ceci est un test" au centre de l'écran.

### Code source :
```rust
#![no_std]
#![no_main]

use cmf_wp2_app::{Api, BUTTON};

cmf_wp2_app::entry!(main);

fn main(api: &'static Api) -> i32 {
    api.rect(0, 0, api.width, api.height, 0x0000);
    let text = "ceci est un test";
    let x = api.width as i16 / 2 - (text.len() as i16 * 8);
    let y = api.height as i16 / 2 - 8;
    api.text(x, y, text, 0xFFFF);
    api.show();
    
    loop {
        let Some(event) = api.event(u32::MAX) else { continue };
        if event.kind == BUTTON { return 0; }
    }
}
```

## 🎨 Personnalisation

- **Nom de l'app** : Modifiez le nom dans `apps/<nom>/Cargo.toml`
- **Icône** : Modifiez `apps/<nom>/icon.svg` (96×96 pixels)
- **Version** : Modifiez dans `apps/<nom>/Cargo.toml` ou passez en paramètre au build

## 📚 Documentation

- [cmf-watch-sdk - App Guide](https://github.com/InukaAsith/cmf-watch-sdk/blob/main/docs/app-guide.md)
- [Émulateur CMF](https://cmf.arnv.dev/emulator/watch-pro-2/)
