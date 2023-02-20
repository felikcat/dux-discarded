#!/bin/bash
# shellcheck disable=SC2034,SC2249
set -a

# === Desktop Environment: KDE ===
# Simple Desktop Display Manager
sddm_autologin="1"
sddm_autologin_session_type="plasma" # plasma, plasmawayland

# A touchscreen keyboard.
kde_install_virtual_keyboard="0"

# Try KWinFT only if KDE's window manager (KWin) seems buggy.
kde_use_kwinft="0"

allow_kde_rice="1"
if [[ ${allow_kde_rice} -eq 1 ]]; then
    kde_general_font="Liberation Sans,11"
    kde_fixed_width_font="Hack,11"
    kde_small_font="Liberation Sans,9"
    kde_toolbar_font="Liberation Sans,10"
    kde_menu_font="Liberation Sans,10"

    # "false" to use the default mouse acceleration profile (Adaptive).
    kde_mouse_accel_flat="true"

    # hintnone, hintslight, hintmedium, hintfull
    # hintfull note: Fonts will look squished in some software; not an issue for GNOME.
    kde_font_hinting="hintslight"

    # none, rgb, bgr, vrgb (Vertical RGB), vbgr (Vertical BGR)
    kde_font_aliasing="none"

    # Disables window titlebars to prioritize mouse & keyboard instead of mouse oriented window management.
    kwin_disable_titlebars="1"

    kwin_animations="false" # true, false

    # Controls window drop-shadows: ShadowNone, ShadowSmall, ShadowMedium, ShadowLarge, ShadowVeryLarge
    kwin_shadow_size="ShadowNone"
fi
