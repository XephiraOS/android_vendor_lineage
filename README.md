# XephiraOS Vendor Configuration

Welcome to the **XephiraOS** vendor configuration repository (`vendor/lineage`). This repository defines platform versioning, product properties, build targets (`bacon`), animations, and device-tree integration contracts.

---

## 📱 Device Tree Configuration Specification

When bringing up a device for XephiraOS or maintaining an official/unofficial device tree (e.g. in `device/<vendor>/<codename>/xephira_<codename>.mk` or `lineage_<codename>.mk`), you can define the following variables to customize device information, maintainer identity, and hardware telemetry.

### 🛠️ Supported Device Tree Variables

| Makefile Variable | Expected Value Format | System Property Generated | Description |
| :--- | :--- | :--- | :--- |
| **`XEPHIRA_MAINTAINER`** | `"MaintainerName"` or `MaintainerName` | `ro.xephira.maintainer`<br>`ro.lineage.maintainer` | Device maintainer name. Automatically falls back to `LINEAGE_MAINTAINER`, `DEVICE_MAINTAINER`, `PRODUCT_MAINTAINER`, `TARGET_MAINTAINER`, or `MAINTAINER`. Quotes are stripped, and spaces are safely converted for `sysprop.mk`. |
| **`XEPHIRA_MAINTAINER_URL`** | `https://github.com/...` or `https://t.me/...` | `ro.xephira.maintainer.url` | Optional URL linking to maintainer's GitHub profile, Telegram, or donation page. Tapping the maintainer row in Settings opens this link. |
| **`XEPHIRA_SOC`** | `"Snapdragon 8 Gen 2"` or `SM8550` | `ro.xephira.soc` | Clean processor/chipset marketing name (e.g. "Snapdragon 8+ Gen 1", "Tensor G3", "Dimensity 9200"). Displayed on the Settings About Phone processor card. |
| **`XEPHIRA_BATTERY`** | `"5000 mAh"` | `ro.xephira.battery` | Typical battery capacity. Overrides/supplements kernel power supply specs in About Phone telemetry. |
| **`XEPHIRA_DISPLAY_SPEC`** | `"6.7\" 120Hz FHD+ AMOLED"` | `ro.xephira.display` | Marketing display specifications displayed in hardware info. |
| **`XEPHIRA_CAMERA`** | `"50MP Main + 12MP Ultra-wide"` | `ro.xephira.camera` | Camera sensor configuration summary. |
| **`XEPHIRA_BUILD_TYPE`** | `OFFICIAL` / `UNOFFICIAL` / `COMMUNITY` | `ro.xephira.buildtype`<br>`ro.xephira.build.status` | Release channel. Defaults to `UNOFFICIAL`. |
| **`WITH_GAPPS`** | `true` or `false` | `ro.xephira.edition` | Sets edition to `GAPPS` or `VANILLA`. |

---

## 📝 Example Device Makefile Configuration

In your device makefile (`xephira_<device>.mk` or `lineage_<device>.mk`):

```makefile
# Inherit common device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit XephiraOS common telephony & platform configurations
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device Identifiers
PRODUCT_NAME := xephira_guacamole
PRODUCT_DEVICE := guacamole
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := GM1911
PRODUCT_MANUFACTURER := OnePlus

# ═══════════════════════════════════════════════════════════════════
#                    XephiraOS Device Information
# ═══════════════════════════════════════════════════════════════════

# Maintainer Identity
XEPHIRA_MAINTAINER := Ajay
XEPHIRA_MAINTAINER_URL := https://github.com/phhgsi

# Hardware Specification Overrides (Displayed in Liquid Glass About Phone)
XEPHIRA_SOC := Snapdragon 855
XEPHIRA_BATTERY := 4000 mAh
XEPHIRA_DISPLAY_SPEC := 6.67" 90Hz QHD+ Fluid AMOLED
XEPHIRA_CAMERA := 48MP Triple Camera
```

> [!NOTE]
> If your device tree sets `XEPHIRA_MAINTAINER` after `common_full_phone.mk` has been inherited, you can also use the helper macro:
> ```makefile
> $(call xephira-set-maintainer, YourName)
> ```

---

## 🚀 Building XephiraOS

Initialize the ROM environment and build using the `bacon` target:

```bash
# Setup build environment
source build/envsetup.sh

# Lunch device combo
lunch xephira_<codename>-userdebug

# Start build
m bacon
```

Upon successful compilation, the terminal will display the official XephiraOS banner including package name, device codename, build type, edition, and resolved maintainer:

```text
╔══════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                          ║
║   ██╗  ██╗███████╗██████╗ ██╗  ██╗██╗██████╗  █████╗      ██████╗ ███████╗               ║
║   ╚██╗██╔╝██╔════╝██╔══██╗██║  ██║██║██╔══██╗██╔══██╗    ██╔═══██╗██╔════╝               ║
║    ╚███╔╝ █████╗  ██████╔╝███████║██║██████╔╝███████║    ██║   ██║███████╗               ║
║    ██╔██╗ ██╔══╝  ██╔═══╝ ██╔══██║██║██╔══██╗██╔══██║    ██║   ██║╚════██║               ║
║   ██╔╝ ██╗███████╗██║     ██║  ██║██║██║  ██║██║  ██║    ╚██████╔╝███████║               ║
║   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚══════╝               ║
║                                                                                          ║
║                       ✔  B U I L D   C O M P L E T E D   S U C C E S S F U L L Y           ║
║                                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                          ║
║   ◆ Package     : XephiraOS-1.0-guacamole-20260916-VANILLA-UNOFFICIAL.zip                ║
║   ◆ Device      : guacamole                                                              ║
║   ◆ Build Type  : UNOFFICIAL (userdebug)                                                 ║
║   ◆ Edition     : VANILLA                                                                ║
║   ◆ Maintainer  : Ajay                                                                   ║
║                                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                          ║
║                 ✨ Thank you for building and choosing XephiraOS! ✨                     ║
║                                                                                          ║
╚══════════════════════════════════════════════════════════════════════════════════════════╝
```

---

## 🎨 Liquid Glass UI Integration (`packages/apps/Settings`)

The system properties exported by this vendor tree are dynamically bound into the **Pure Liquid Glass** settings dashboard and about phone screens:
* `ro.xephira.maintainer`: Displayed under **About Phone > OS & Firmware** and **Firmware Version** with a verified maintainer badge.
* `ro.xephira.maintainer.url`: Opens the maintainer's personal profile or contact handle on tap.
* `ro.xephira.soc`: Feeds into the processor bento card.
* `ro.xephira.battery`: Supplements battery telemetry in About Phone.
* `ro.xephira.display`: Shown in display & hardware information.
