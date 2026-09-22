# Inherit common Lineage stuff
$(call inherit-product, vendor/lineage/config/common_mobile.mk)

PRODUCT_SIZE := full

# Include GoogleSansFlex font
$(call inherit-product-if-exists, external/google-fonts/google-sans-flex/fonts.mk)

# Apps
PRODUCT_PACKAGES += \
    Profiles \
    Seedvault

ifeq ($(WITH_GMS),false)
PRODUCT_PACKAGES += \
    Camelot \
    Etar \
    Recorder \
    Twelve
endif

ifneq ($(PRODUCT_NO_CAMERA),true)
PRODUCT_PACKAGES += \
    Aperture
endif

ifeq ($(WITH_GMS),false)
ifneq ($(TARGET_EXCLUDES_AUDIOFX),true)
PRODUCT_PACKAGES += \
    AudioFX
endif
endif

# Extra cmdline tools
PRODUCT_PACKAGES += \
    unrar \
    zstd

# Fonts
PRODUCT_PACKAGES += \
    fonts_customization.xml \
    FontGoogleSansFlexOverlay

# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/lineage/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/lineage/overlay/dictionaries
