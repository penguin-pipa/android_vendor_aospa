#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Architecture.
TARGET_KERNEL_ARCH := arm64

# Cross Compiler.
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(shell pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
TARGET_KERNEL_CROSS_COMPILE_ARM32_PREFIX := $(shell pwd)/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

# Enable LLVM Support if GCC is not used.
KERNEL_LLVM_SUPPORT ?= true

ifeq ($(KERNEL_NEW_GCC_SUPPORT),true)
    KERNEL_LLVM_SUPPORT := false
endif

# Use the Clang version requested by the device, if any. Consumed by
# vendor/qcom/build/tasks/kernel_definitions.mk via KERNEL_CUSTOM_LLVM.
# Devices give the bare revision (r596125), the prebuilt dirs are clang-<rev>.
ifneq ($(strip $(KERNEL_CLANG_VERSION)),)
KERNEL_CUSTOM_LLVM ?= true
KERNEL_CUSTOM_LLVM_PATH ?= $(shell pwd)/prebuilts/clang/host/linux-x86/clang-$(KERNEL_CLANG_VERSION)
ifeq ($(wildcard $(KERNEL_CUSTOM_LLVM_PATH)/bin/clang),)
$(warning KERNEL_CLANG_VERSION=$(KERNEL_CLANG_VERSION) but clang is missing under $(KERNEL_CUSTOM_LLVM_PATH))
endif
endif

# Enable SDLLVM Support.
ifneq (,$(filter 3.18 4.4 4.9, $(TARGET_KERNEL_VERSION)))
KERNEL_SD_LLVM_SUPPORT ?= true
endif

# Qualcomm kernel.
ifeq ($(TARGET_PREBUILT_KERNEL),)
TARGET_COMPILE_WITH_MSM_KERNEL := true
endif

# Defining BOARD_PREBUILT_DTBOIMAGE here as AndroidBoardCommon.mk
# is included before build/core/Makefile, where it is required to
# set the dependencies on prebuilt_dtbo.img based on definition of
# BOARD_PREBUILT_DTBOIMAGE
ifneq ($(strip $(BOARD_KERNEL_SEPARATED_DTBO)),)
BOARD_PREBUILT_DTBOIMAGE ?= $(PRODUCT_OUT)/prebuilt_dtbo.img
endif
