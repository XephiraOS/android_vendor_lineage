ifeq ($(filter true,$(WITH_GMS) $(WITH_GAPPS)),true)
    # Special handling for Android TV
    ifeq ($(PRODUCT_IS_ATV),true)
        ifneq (,$(wildcard vendor/partner_gms-tv))
            ifneq ($(GMS_MAKEFILE),)
                # Specify the GMS makefile you want to use, for example:
                #   - gms.mk            - default Android TV GMS
                #   - gms_gtv.mk        - default Google TV GMS
                #   - gms_minimal.mk    - minimal Android TV GMS
                $(call inherit-product, vendor/partner_gms-tv/products/$(GMS_MAKEFILE))
            else
                $(call inherit-product-if-exists, vendor/partner_gms-tv/products/gms.mk)
            endif
            $(call inherit-product-if-exists, vendor/partner_gms-tv/products/mainline_modules.mk)
        endif
    # Special handling for Android Automotive
    else ifeq ($(PRODUCT_IS_AUTOMOTIVE),true)
        ifneq (,$(wildcard vendor/partner_gms-car))
            ifneq ($(GMS_MAKEFILE),)
                $(call inherit-product, vendor/partner_gms-car/products/$(GMS_MAKEFILE))
            else
                $(call inherit-product-if-exists, vendor/partner_gms-car/products/gms.mk)
            endif
        endif
    # Standard Mobile / Phone / Tablet
    else
        # Pixel / GMS Prebuilts
        ifneq (,$(wildcard vendor/gms))
            ifeq ($(TARGET_USES_PICO_GAPPS),true)
                $(call inherit-product, vendor/gms/gms_pico.mk)
            else ifeq ($(TARGET_USES_MINI_GAPPS),true)
                $(call inherit-product, vendor/gms/gms_mini.mk)
            else
                $(call inherit-product, vendor/gms/gms_full.mk)
            endif

            # Pixel style and icon overlays
            $(call inherit-product-if-exists, vendor/google/overlays/ThemeIcons/config.mk)
            $(call inherit-product-if-exists, vendor/pixel-style/config/common.mk)

            # Don't dexpreopt prebuilts for GMS
            DONT_DEXPREOPT_PREBUILTS := true
        else ifneq (,$(wildcard vendor/gapps))
            $(call inherit-product-if-exists, vendor/gapps/gapps.mk)
        endif

        ifneq (,$(wildcard vendor/partner_gms))
            # Specify the GMS makefile you want to use, for example:
            #   - fi.mk             - Project Fi
            #   - gms.mk            - default GMS
            #   - gms_go.mk         - low ram devices
            #   - gms_go_2gb.mk     - low ram devices (2GB)
            #   - gms_64bit_only.mk - devices supporting 64-bit only
            #   - gms_minimal.mk    - minimal GMS
            ifneq ($(GMS_MAKEFILE),)
                $(call inherit-product, vendor/partner_gms/products/$(GMS_MAKEFILE))
            else
                $(call inherit-product-if-exists, vendor/partner_gms/products/gms.mk)
            endif
        endif

        ifneq (,$(wildcard vendor/partner_modules))
            # Specify the mainline module makefile you want to use, for example:
            #   - mainline_modules.mk              - updatable apex
            #   - mainline_modules_flatten_apex.mk - flatten apex
            #   - mainline_modules_low_ram.mk      - low ram devices
            ifneq ($(MAINLINE_MODULES_MAKEFILE),)
                $(call inherit-product, vendor/partner_modules/build/$(MAINLINE_MODULES_MAKEFILE))
            endif
        endif
    endif

    # Propagate GMS flag to GAPPS for versioning and package flavor
    WITH_GAPPS := true
endif
