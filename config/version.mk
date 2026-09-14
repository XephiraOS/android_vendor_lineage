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

PRODUCT_VERSION_MAJOR ?= 24
PRODUCT_VERSION_MINOR ?= 0

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

# Maintainer Information
XEPHIRA_MAINTAINER ?= UNKNOWN

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
ifeq ($(WITH_GAPPS), true)
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
    ro.xephira.maintainer=$(XEPHIRA_MAINTAINER) \
    ro.modversion=$(XEPHIRA_VERSION) \
    ro.lineage.version=$(XEPHIRA_VERSION) \
    ro.lineage.display.version=$(XEPHIRA_DISPLAY_VERSION) \
    ro.lineage.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.lineage.releasetype=$(XEPHIRA_BUILD_TYPE)
