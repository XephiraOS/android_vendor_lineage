# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
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

# -----------------------------------------------------------------
# XephiraOS OTA update package

ifneq ($(ZIP_NAME),)
    XEPHIRA_TARGET_PACKAGE := $(PRODUCT_OUT)/$(ZIP_NAME).zip
else
    XEPHIRA_TARGET_PACKAGE := $(PRODUCT_OUT)/lineage-$(LINEAGE_VERSION).zip
endif

LINEAGE_TARGET_PACKAGE := $(XEPHIRA_TARGET_PACKAGE)

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

$(XEPHIRA_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(XEPHIRA_TARGET_PACKAGE)
	$(hide) $(SHA256) $(XEPHIRA_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(XEPHIRA_TARGET_PACKAGE).sha256sum
	@echo -e "" >&2
	@echo -e "\033[1;36m╔══════════════════════════════════════════════════════════════════════════════════════════╗\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                                                                                          \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;36m██╗  ██╗███████╗██████╗ ██╗  ██╗██╗██████╗  █████╗      ██████╗ ███████╗\033[0m               \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;36m╚██╗██╔╝██╔════╝██╔══██╗██║  ██║██║██╔══██╗██╔══██╗    ██╔═══██╗██╔════╝\033[0m               \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m    \033[1;36m╚███╔╝ █████╗  ██████╔╝███████║██║██████╔╝███████║    ██║   ██║███████╗\033[0m               \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m    \033[1;36m██╔██╗ ██╔══╝  ██╔═══╝ ██╔══██║██║██╔══██╗██╔══██║    ██║   ██║╚════██║\033[0m               \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;36m██╔╝ ██╗███████╗██║     ██║  ██║██║██║  ██║██║  ██║    ╚██████╔╝███████║\033[0m               \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;36m╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚══════╝\033[0m               \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                                                                                          \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                       \033[1;32m✔  B U I L D   C O M P L E T E D   S U C C E S S F U L L Y\033[0m           \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                                                                                          \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m╠══════════════════════════════════════════════════════════════════════════════════════════╣\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                                                                                          \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;35m◆\033[0m \033[1;37mPackage     :\033[0m \033[1;36m$(notdir $(XEPHIRA_TARGET_PACKAGE))\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;35m◆\033[0m \033[1;37mDevice      :\033[0m \033[1;32m$(TARGET_PRODUCT_SHORT)\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;35m◆\033[0m \033[1;37mBuild Type  :\033[0m \033[1;33m$(XEPHIRA_BUILD_TYPE)\033[0m \033[0;37m($(TARGET_BUILD_VARIANT))\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;35m◆\033[0m \033[1;37mEdition     :\033[0m \033[1;36m$(XEPHIRA_EDITION)\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;35m◆\033[0m \033[1;37mMaintainer  :\033[0m \033[1;37m$(XEPHIRA_MAINTAINER)\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;35m◆\033[0m \033[1;37mOutput Size :\033[0m \033[1;32m$$([ -f $(XEPHIRA_TARGET_PACKAGE) ] && du -h $(XEPHIRA_TARGET_PACKAGE) | cut -f1)\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m   \033[1;35m◆\033[0m \033[1;37mSHA256      :\033[0m \033[0;37m$$([ -f $(XEPHIRA_TARGET_PACKAGE).sha256sum ] && cut -d' ' -f1 $(XEPHIRA_TARGET_PACKAGE).sha256sum)\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                                                                                          \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m╠══════════════════════════════════════════════════════════════════════════════════════════╣\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                                                                                          \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                 \033[1;37m✨ Thank you for building and choosing XephiraOS! ✨\033[0m                     \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m║\033[0m                                                                                          \033[1;36m║\033[0m" >&2
	@echo -e "\033[1;36m╚══════════════════════════════════════════════════════════════════════════════════════════╝\033[0m" >&2
	@echo -e "" >&2

.PHONY: bacon
bacon: $(XEPHIRA_TARGET_PACKAGE) $(DEFAULT_GOAL)

