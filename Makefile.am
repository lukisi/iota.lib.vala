NULL = 
ACLOCAL_AMFLAGS = -I m4

lib_LTLIBRARIES = \
	libiota-vala.la \
	$(NULL)

EXTRA_PROGRAMS = \
	test_app \
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
	crypto/curl.vala \
	crypto/dep_ccurl.vapi \
	api/api.vala \
	api/api_commands.vala \
	utils/make_request.vala \
	errors/input_errors.vala \
	errors/request_errors.vala \
	$(NULL)

libiota_vala_la_VALAFLAGS = \
	-H iota-vala.h \
	--library iota-vala \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	--vapidir $(GIO_PREFIX)/share/vala/vapi \
	--pkg gio-2.0 \
	--vapidir $(LIBSOUP_PREFIX)/share/vala-0.32/vapi \
	--pkg libsoup-2.4 \
	--vapidir $(JSON_PREFIX)/share/vala-0.32/vapi \
	--pkg json-glib-1.0 \
	$(NULL)

libiota_vala_la_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GIO_CFLAGS) \
	$(GEE_CFLAGS) \
	$(LIBSOUP_CFLAGS) \
	$(JSON_CFLAGS) \
	$(CCURL_CFLAGS) \
	$(NULL)

libiota_vala_la_LIBADD = \
	$(GOBJECT_LIBS) \
	$(GIO_LIBS) \
	$(GEE_LIBS) \
	$(LIBSOUP_LIBS) \
	$(JSON_LIBS) \
	$(CCURL_LIBS) \
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
	$(CCURL_CFLAGS) \
	$(NULL)

test_converter_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(CCURL_LIBS) \
	$(builddir)/libiota-vala.la \
	$(NULL)

test_app_SOURCES = \
	extra/test_app/test_app.vala \
	iota-vala.vapi \
	$(NULL)

test_app_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	--vapidir $(GIO_PREFIX)/share/vala/vapi \
	--pkg gio-2.0 \
	--vapidir $(LIBSOUP_PREFIX)/share/vala-0.32/vapi \
	--pkg libsoup-2.4 \
	--vapidir $(JSON_PREFIX)/share/vala-0.32/vapi \
	--pkg json-glib-1.0 \
	$(NULL)

test_app_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(GIO_CFLAGS) \
	$(LIBSOUP_CFLAGS) \
	$(JSON_CFLAGS) \
	$(CCURL_CFLAGS) \
	$(NULL)

test_app_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(GIO_LIBS) \
	$(LIBSOUP_LIBS) \
	$(JSON_LIBS) \
	$(CCURL_LIBS) \
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

