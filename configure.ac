AC_PREREQ([2.68])
AC_INIT([iotalib-vala],[0.1])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([foreign] [subdir-objects] [1.11])
AM_SILENT_RULES([yes])

dnl This avoids dumb '-g -O2' autoconf's default, but won't 
dnl prevent user from setting a specific value for CFLAGS
: ${CFLAGS=""}

LT_INIT
AM_PROG_CC_C_O

dnl Check for vala
AM_PROG_VALAC([0.32.0])

AM_MAINTAINER_MODE([enable])

PKG_CHECK_MODULES([GOBJECT], [gobject-2.0 glib-2.0])
PKG_CHECK_MODULES([GIO], [gio-2.0])
PKG_CHECK_VAR([GIO_PREFIX], [gio-2.0], [prefix])
PKG_CHECK_MODULES([GEE], [gee-0.8])
PKG_CHECK_VAR([GEE_PREFIX], [gee-0.8], [prefix])
PKG_CHECK_MODULES([LIBSOUP], [libsoup-2.4 >= 2.26])
PKG_CHECK_VAR([LIBSOUP_PREFIX], [libsoup-2.4 >= 2.26], [prefix])
PKG_CHECK_MODULES([JSON], [json-glib-1.0])
PKG_CHECK_VAR([JSON_PREFIX], [json-glib-1.0], [prefix])
PKG_CHECK_MODULES([CCURL], [ccurl >= 0.2.0])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile iota-vala.pc])
AC_OUTPUT

