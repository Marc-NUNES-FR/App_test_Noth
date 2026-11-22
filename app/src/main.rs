#![no_std]
#![no_main]

use cmf_wp2_app::{Api, BUTTON};

cmf_wp2_app::entry!(main);

fn main(api: &'static Api) -> i32 {
    // Effacer l'écran en noir
    api.rect(0, 0, api.width, api.height, 0x0000);
    
    // Afficher le texte "ceci est un test" au centre
    let text = "ceci est un test";
    let x = api.width as i16 / 2 - (text.len() as i16 * 8);
    let y = api.height as i16 / 2 - 8;
    api.text(x, y, text, 0xFFFF);
    
    api.show();
    
    // Attendre un appui sur le bouton pour quitter
    loop {
        let Some(event) = api.event(u32::MAX) else { continue };
        if event.kind == BUTTON {
            return 0;
        }
    }
}
