NULL = 
ACLOCAL_AMFLAGS = -I m4

lib_LTLIBRARIES = \
	libiota-vala.la \
	$(NULL)

TESTS = \
	test_converter \
	$(NULL)

check_PROGRAMS = \
	test_converter \
	$(NULL)

libiota_vala_la_SOURCES = \
	libiota.vala \
	crypto/converter.vala \
	$(NULL)

libiota_vala_la_VALAFLAGS = \
	-H iota-vala.h \
	--library iota-vala \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	$(NULL)

libiota_vala_la_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(NULL)

libiota_vala_la_LIBADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(NULL)

test_converter_SOURCES = \
	testsuites/test_converter/test_converter.vala \
	iota-vala.vapi \
	$(NULL)

test_converter_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	$(NULL)

test_converter_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(NULL)

test_converter_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(builddir)/libiota-vala.la \
	$(NULL)

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = \
	iota-vala.vapi \
	iota-vala.deps \
	$(NULL)

include_HEADERS = \
	iota-vala.h \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = \
	iota-vala.pc \
	$(NULL)

EXTRA_DIST = \
	iota-vala.pc.in \
	$(NULL)

MAINTAINERCLEANFILES = \
	$(srcdir)/iota-vala.vapi \
	$(NULL)

iota-vala.vapi: libiota_vala_la_vala.stamp
	$(NULL)

