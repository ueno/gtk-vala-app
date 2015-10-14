# I chose to use recursive automake so I can use nobase_ and avoid
# 5 different directory declarations
SUBDIRS = icons

app_resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --sourcedir=$(srcdir) --generate-dependencies $(srcdir)/com.example.Gtk.ValaApplication.data.gresource.xml)

appsdir = $(datadir)/applications
apps_DATA = com.example.Gtk.ValaApplication.desktop

@INTLTOOL_DESKTOP_RULE@

gsettings_SCHEMAS = com.example.Gtk.ValaApplication.gschema.xml

@GSETTINGS_RULES@

appstream_XML = com.example.Gtk.ValaApplication.appdata.xml

@APPSTREAM_XML_RULES@
@INTLTOOL_XML_RULE@

com.example.Gtk.ValaApplication.service: com.example.Gtk.ValaApplication.service.in
	$(AM_V_GEN) sed \
		-e "s|[@]PACKAGE_NAME@|$(PACKAGE_NAME)|g" \
		-e "s|[@]pkgdatadir@|$(pkgdatadir)|g" \
		-e "s|[@]pkglibdir@|$(pkglibdir)|g" \
		$< > $@

servicedir = $(datadir)/dbus-1/services
service_DATA = com.example.Gtk.ValaApplication.service

EXTRA_DIST = \
	com.example.Gtk.ValaApplication.desktop.in \
	com.example.Gtk.ValaApplication.service.in \
	com.example.Gtk.ValaApplication.data.gresource.xml \
	$(gsettings_SCHEMAS) \
	com.example.Gtk.ValaApplication.appdata.xml.in \
	$(app_resource_files) \
	$(NULL)

CLEANFILES = \
	com.example.Gtk.ValaApplication.service \
	com.example.Gtk.ValaApplication.appdata.xml \
	com.example.Gtk.ValaApplication.appdata.valid \
	$(apps_DATA) \
	*.valid \
	gschemas.compiled \
	$(NULL)

# For uninstalled use
all-local:
	$(GLIB_COMPILE_SCHEMAS) $(builddir)

-include $(top_srcdir)/git.mk
