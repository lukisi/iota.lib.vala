NULL = 
ACLOCAL_AMFLAGS = -I m4

lib_LTLIBRARIES = \
	libiota-vala.la \
	$(NULL)

EXTRA_PROGRAMS = \
	test_app \
	iota_seed_checker \
	attach_spam_to_tangle \
	send_tokens \
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
	api/api_results.vala \
	utils/make_request.vala \
	utils/utils.vala \
	utils/input_validator.vala \
	errors/input_errors.vala \
	errors/request_errors.vala \
	crypto/bundle.vala \
	crypto/signing.vala \
	crypto/pow.vala \
	crypto/hmac.vala \
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

iota_seed_checker_SOURCES = \
	extra/iota_seed_checker/iota_seed_checker.vala \
	iota-vala.vapi \
	$(NULL)

iota_seed_checker_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	--vapidir $(GIO_PREFIX)/share/vala/vapi \
	--pkg gio-2.0 \
	$(NULL)

iota_seed_checker_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(GIO_CFLAGS) \
	$(NULL)

iota_seed_checker_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(GIO_LIBS) \
	$(builddir)/libiota-vala.la \
	$(NULL)

attach_spam_to_tangle_SOURCES = \
	extra/attach_spam_to_tangle/attach_spam_to_tangle.vala \
	iota-vala.vapi \
	$(NULL)

attach_spam_to_tangle_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	--vapidir $(GIO_PREFIX)/share/vala/vapi \
	--pkg gio-2.0 \
	$(NULL)

attach_spam_to_tangle_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(GIO_CFLAGS) \
	$(NULL)

attach_spam_to_tangle_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(GIO_LIBS) \
	$(builddir)/libiota-vala.la \
	$(NULL)

send_tokens_SOURCES = \
	extra/send_tokens/send_tokens.vala \
	iota-vala.vapi \
	$(NULL)

send_tokens_VALAFLAGS = \
	--vapidir $(GEE_PREFIX)/share/vala/vapi \
	--pkg gee-0.8 \
	--vapidir $(GIO_PREFIX)/share/vala/vapi \
	--pkg gio-2.0 \
	$(NULL)

send_tokens_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(GIO_CFLAGS) \
	$(NULL)

send_tokens_LDADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(GIO_LIBS) \
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

