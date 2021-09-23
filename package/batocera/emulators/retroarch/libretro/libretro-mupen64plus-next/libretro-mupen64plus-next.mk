################################################################################
#
# MUPEN64PLUS-NEXT
#
################################################################################
# Version.: Commits on Aug 12, 2021
LIBRETRO_MUPEN64PLUS_NEXT_VERSION = 7280cc27a55cc20ac16d4b6b403ca6fb22ee44c3
LIBRETRO_MUPEN64PLUS_NEXT_SITE = $(call github,libretro,mupen64plus-libretro-nx,$(LIBRETRO_MUPEN64PLUS_NEXT_VERSION))
LIBRETRO_MUPEN64PLUS_NEXT_LICENSE = GPLv2
LIBRETRO_MUPEN64PLUS_NEXT_DEPENDENCIES = host-nasm retroarch

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBRETRO_MUPEN64PLUS_DEPENDENCIES += rpi-userland
endif

LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CFLAGS = $(TARGET_CFLAGS)
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS)
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_LDFLAGS = $(TARGET_LDFLAGS)
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS=
LIBRETRO_MUPEN64PLUS_NEXT_BOARD=

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI4),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi4_64
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi3_64-mesa
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI2),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi2-mesa

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=arm FORCE_GLES=1 WITH_DYNAREC=arm HAVE_NEON=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_XU4),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid
LIBRETRO_MUPEN64PLUS_NEXT_BOARD = ODROID-XU
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=arm FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S905GEN3),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid64
LIBRETRO_MUPEN64PLUS_NEXT_BOARD = ODROID-C4
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ORANGEPI_ZERO2),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = h616
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S905),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid64
LIBRETRO_MUPEN64PLUS_NEXT_BOARD = ODROID-C2
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S912),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = s912

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_X86),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = unix
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=i686 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_X86_64),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = unix
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=x86_64 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1 LLE=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3399),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi4
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid64
LIBRETRO_MUPEN64PLUS_NEXT_BOARD = N2
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1 GL_LIB=-lGLESv2

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3288),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = RK3288

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_LIBRETECH_H5),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = h5

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ORANGEPI_PC),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = armv
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=arm FORCE_GLES=1 WITH_DYNAREC=arm HAVE_NEON=1

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_PS5000),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = armv
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=arm FORCE_GLES=1 WITH_DYNAREC=arm HAVE_NEON=1
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CFLAGS += -DEGL_NO_X11
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CXXFLAGS += -DEGL_NO_X11

else ifeq ($(BR2_aarch64),y)
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = unix
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES=1
else
LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM=$(LIBRETRO_PLATFORM)
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_LDFLAGS += -lmali
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER),)
	ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
		LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CFLAGS += -DEGL_NO_X11
		LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CXXFLAGS += -DEGL_NO_X11
	endif
endif


define LIBRETRO_MUPEN64PLUS_NEXT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CFLAGS)" \
		CXXFLAGS="$(LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CXXFLAGS)" \
		LDFLAGS="$(LIBRETRO_MUPEN64PLUS_NEXT_TARGET_LDFLAGS)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM)" \
		BOARD="$(LIBRETRO_MUPEN64PLUS_NEXT_BOARD)" $(LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS)
endef

define LIBRETRO_MUPEN64PLUS_NEXT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mupen64plus_next_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/mupen64plus-next_libretro.so
endef

$(eval $(generic-package))
