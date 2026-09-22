#
# Copyright (C) 2024 Project Infinity X
# Copyright (C) 2026 XephiraOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# ═══════════════════════════════════════════════════════════════════
#                    XephiraOS Platform Versioning
# ═══════════════════════════════════════════════════════════════════

PRODUCT_VERSION_MAJOR ?= 23
PRODUCT_VERSION_MINOR ?= 2

# Android Platform Version
ifndef ANDROID_VERSION
    ifeq ($(PRODUCT_VERSION_MAJOR),24)
        ANDROID_VERSION := 17
    else
        ANDROID_VERSION := 16
    endif
endif

# XephiraOS Release Version
XEPHIRAVERSION ?= 1.0
XEPHIRA_VERSION_CODE := $(XEPHIRAVERSION)

# ═══════════════════════════════════════════════════════════════════
#                    Build Configuration & Metadata
# ═══════════════════════════════════════════════════════════════════

# Build Type: OFFICIAL / UNOFFICIAL / COMMUNITY / NIGHTLY / RELEASE
XEPHIRA_BUILD_TYPE ?= UNOFFICIAL
ifndef XEPHIRA_BUILD_TYPE
    ifdef RELEASE_TYPE
        XEPHIRA_BUILD_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^XEPHIRA_||g' -e 's|^LINEAGE_||g')
    endif
endif

# Fallback filter to reset invalid types
ifeq ($(filter OFFICIAL UNOFFICIAL COMMUNITY NIGHTLY RELEASE EXPERIMENTAL,$(XEPHIRA_BUILD_TYPE)),)
    XEPHIRA_BUILD_TYPE := UNOFFICIAL
endif

# ═══════════════════════════════════════════════════════════════════
#                    Maintainer Information
# ═══════════════════════════════════════════════════════════════════

_xephira_empty :=
_xephira_space := $(_xephira_empty) $(_xephira_empty)

# Resolve maintainer from all common environment & makefile variables
ifndef XEPHIRA_MAINTAINER
    ifdef LINEAGE_MAINTAINER
        XEPHIRA_MAINTAINER := $(LINEAGE_MAINTAINER)
    else ifdef DEVICE_MAINTAINER
        XEPHIRA_MAINTAINER := $(DEVICE_MAINTAINER)
    else ifdef PRODUCT_MAINTAINER
        XEPHIRA_MAINTAINER := $(PRODUCT_MAINTAINER)
    else ifdef TARGET_MAINTAINER
        XEPHIRA_MAINTAINER := $(TARGET_MAINTAINER)
    else ifdef MAINTAINER
        XEPHIRA_MAINTAINER := $(MAINTAINER)
    endif
endif

# Strip quotes and leading/trailing whitespace
XEPHIRA_MAINTAINER := $(subst ",,$(XEPHIRA_MAINTAINER))
XEPHIRA_MAINTAINER := $(subst ',,$(XEPHIRA_MAINTAINER))
XEPHIRA_MAINTAINER := $(strip $(XEPHIRA_MAINTAINER))

ifeq ($(XEPHIRA_MAINTAINER),)
    XEPHIRA_MAINTAINER := UNKNOWN
endif

# System properties cannot contain raw spaces in PRODUCT_PRODUCT_PROPERTIES
# because build/make/core/sysprop.mk treats spaces as property delimiters.
# We convert spaces to underscores for the system property while keeping
# XEPHIRA_MAINTAINER untouched for terminal banners and logs.
XEPHIRA_MAINTAINER_PROP := $(subst $(_xephira_space),_,$(XEPHIRA_MAINTAINER))

# Helper macro to update maintainer if defined later in device makefile
define xephira-set-maintainer
    $(eval XEPHIRA_MAINTAINER := $(strip $(subst ",,$(subst ',,$(1)))))
    $(eval XEPHIRA_MAINTAINER_PROP := $(subst $$(_xephira_space),_,$(XEPHIRA_MAINTAINER)))
    $(eval PRODUCT_PRODUCT_PROPERTIES += ro.xephira.maintainer=$(XEPHIRA_MAINTAINER_PROP) ro.lineage.maintainer=$(XEPHIRA_MAINTAINER_PROP))
endef

# Date & Timestamps
XEPHIRA_DATE_YEAR  := $(shell date -u +%Y)
XEPHIRA_DATE_MONTH := $(shell date -u +%m)
XEPHIRA_DATE_DAY   := $(shell date -u +%d)

ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    XEPHIRA_DATE_TIME := _$(shell date -u +%H%M%S)
endif

XEPHIRA_BUILD_DATE := $(XEPHIRA_DATE_YEAR)$(XEPHIRA_DATE_MONTH)$(XEPHIRA_DATE_DAY)$(XEPHIRA_DATE_TIME)

# ═══════════════════════════════════════════════════════════════════
#                    Device & Package Identifiers
# ═══════════════════════════════════════════════════════════════════

# Extract short product/device codename
ifneq ($(XEPHIRA_BUILD),)
    TARGET_PRODUCT_SHORT := $(subst xephira_,,$(subst lineage_,,$(XEPHIRA_BUILD)))
else ifneq ($(TARGET_PRODUCT),)
    TARGET_PRODUCT_SHORT := $(subst xephira_,,$(subst lineage_,,$(TARGET_PRODUCT)))
else
    TARGET_PRODUCT_SHORT := generic
endif

# Package Flavor (VANILLA vs GAPPS)
ifeq ($(filter true,$(WITH_GMS) $(WITH_GAPPS)),true)
    XEPHIRA_EDITION := GAPPS
else
    XEPHIRA_EDITION := VANILLA
endif

# Version Strings
XEPHIRA_VERSION := XephiraOS-$(XEPHIRAVERSION)-$(TARGET_PRODUCT_SHORT)-$(XEPHIRA_BUILD_DATE)-$(XEPHIRA_EDITION)-$(XEPHIRA_BUILD_TYPE)
XEPHIRA_DISPLAY_VERSION := XephiraOS-$(XEPHIRAVERSION)-$(XEPHIRA_BUILD_TYPE)
XEPHIRA_DISPLAY_BUILDTYPE := $(XEPHIRA_BUILD_TYPE)
XEPHIRA_MOD_VERSION ?= $(XEPHIRAVERSION)
XEPHIRA_FINGERPRINT := XephiraOS/$(XEPHIRA_MOD_VERSION)/$(TARGET_PRODUCT_SHORT)/$(XEPHIRA_BUILD_DATE)

# Zip Output Name
ZIP_NAME := XephiraOS-$(XEPHIRAVERSION)-$(TARGET_PRODUCT_SHORT)-$(XEPHIRA_BUILD_DATE)-$(XEPHIRA_EDITION)-$(XEPHIRA_BUILD_TYPE)

# ═══════════════════════════════════════════════════════════════════
#                    LineageOS Compatibility Layer
# ═══════════════════════════════════════════════════════════════════

LINEAGE_BUILDTYPE := $(XEPHIRA_BUILD_TYPE)
LINEAGE_VERSION := $(XEPHIRA_VERSION)
LINEAGE_DISPLAY_VERSION := $(XEPHIRA_DISPLAY_VERSION)

# ═══════════════════════════════════════════════════════════════════
#                    System & Product Properties
# ═══════════════════════════════════════════════════════════════════

PRODUCT_PRODUCT_PROPERTIES += \
    ro.xephira.android.version=$(ANDROID_VERSION) \
    ro.xephira.build.version=$(XEPHIRA_VERSION) \
    ro.xephira.build.status=$(XEPHIRA_BUILD_TYPE) \
    ro.xephira.build.date=$(XEPHIRA_BUILD_DATE) \
    ro.xephira.buildtype=$(XEPHIRA_BUILD_TYPE) \
    ro.xephira.fingerprint=$(XEPHIRA_FINGERPRINT) \
    ro.xephira.device=$(TARGET_PRODUCT_SHORT) \
    ro.xephira.version=$(XEPHIRAVERSION) \
    ro.xephira.edition=$(XEPHIRA_EDITION) \
    ro.xephira.maintainer=$(XEPHIRA_MAINTAINER_PROP) \
    ro.lineage.maintainer=$(XEPHIRA_MAINTAINER_PROP) \
    ro.modversion=$(XEPHIRA_VERSION) \
    ro.lineage.version=$(XEPHIRA_VERSION) \
    ro.lineage.display.version=$(XEPHIRA_DISPLAY_VERSION) \
    ro.lineage.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.lineage.releasetype=$(XEPHIRA_BUILD_TYPE)

# ═══════════════════════════════════════════════════════════════════
#             Device Tree Custom Hardware Properties
# ═══════════════════════════════════════════════════════════════════

# Optional maintainer profile URL
ifdef XEPHIRA_MAINTAINER_URL
    PRODUCT_PRODUCT_PROPERTIES += ro.xephira.maintainer.url=$(strip $(XEPHIRA_MAINTAINER_URL))
endif

# Optional SoC / Processor model override (e.g. "Snapdragon 8 Gen 2", "Tensor G3")
ifndef XEPHIRA_SOC
    ifdef TARGET_SOC
        XEPHIRA_SOC := $(TARGET_SOC)
    endif
endif
ifdef XEPHIRA_SOC
    XEPHIRA_SOC_PROP := $(subst $(_xephira_space),_,$(strip $(subst ",,$(subst ',,$(XEPHIRA_SOC)))))
    PRODUCT_PRODUCT_PROPERTIES += ro.xephira.soc=$(XEPHIRA_SOC_PROP)
endif

# Optional Battery capacity override (e.g. "5000 mAh")
ifdef XEPHIRA_BATTERY
    XEPHIRA_BATTERY_PROP := $(subst $(_xephira_space),_,$(strip $(subst ",,$(subst ',,$(XEPHIRA_BATTERY)))))
    PRODUCT_PRODUCT_PROPERTIES += ro.xephira.battery=$(XEPHIRA_BATTERY_PROP)
endif

# Optional Display specification override (e.g. "6.7\" 120Hz AMOLED")
ifdef XEPHIRA_DISPLAY_SPEC
    XEPHIRA_DISPLAY_SPEC_PROP := $(subst $(_xephira_space),_,$(strip $(subst ",,$(subst ',,$(XEPHIRA_DISPLAY_SPEC)))))
    PRODUCT_PRODUCT_PROPERTIES += ro.xephira.display=$(XEPHIRA_DISPLAY_SPEC_PROP)
endif

# Optional Camera specification override (e.g. "50MP Main + 12MP Ultra-wide")
ifdef XEPHIRA_CAMERA
    XEPHIRA_CAMERA_PROP := $(subst $(_xephira_space),_,$(strip $(subst ",,$(subst ',,$(XEPHIRA_CAMERA)))))
    PRODUCT_PRODUCT_PROPERTIES += ro.xephira.camera=$(XEPHIRA_CAMERA_PROP)
endif
