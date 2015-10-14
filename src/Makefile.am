bin_PROGRAMS = gtk-vala-app

gtk_vala_app_SOURCES = main.vala window.vala resources.c
gtk_vala_app_LDADD = $(DEPS_LIBS)

gresource_file = $(top_srcdir)/data/com.example.Gtk.ValaApplication.data.gresource.xml

AM_CPPFLAGS = -include config.h $(DEPS_CFLAGS)
AM_VALAFLAGS = --target-glib=2.38 --vapidir=$(srcdir) --pkg config --pkg gtk+-3.0 --gresources $(gresource_file)

resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/data $(gresource_file))
resources.c: $(gresource_file) $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/data --generate-source $<

EXTRA_DIST = config.vapi

GITIGNOREFILES = *.c *.stamp

-include $(top_srcdir)/git.mk
