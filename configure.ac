AC_PREREQ(2.63)
AC_INIT([gtk-vala-app], [0.1],
        [bugs@vala-app.example.com],
        [gtk-vala-app],
        [http://www.example.com/gtk-vala-app/])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])

PACKAGE_DESKTOP_NAME=com.example.Gtk.ValaApplication
AC_SUBST(PACKAGE_DESKTOP_NAME)
AC_DEFINE_UNQUOTED(PACKAGE_DESKTOP_NAME, "$PACKAGE_DESKTOP_NAME",
		   [The desktop ID of the application.])

AM_INIT_AUTOMAKE([1.12 dist-xz no-dist-gzip foreign tar-ustar no-define serial-tests -Wno-portability])

PACKAGE_DBUS_PATH=/`echo $PACKAGE_DESKTOP_NAME | sed 's,\.,/,g'`
AC_SUBST(PACKAGE_DBUS_PATH)

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

GETTEXT_PACKAGE=$PACKAGE_DESKTOP_NAME
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE",
                   [The prefix for our gettext translation domains.])
IT_PROG_INTLTOOL([0.50.1])

AC_PROG_CC
AM_PROG_CC_C_O
LT_INIT([disable-static])

PKG_PROG_PKG_CONFIG([0.22])

APPSTREAM_XML
GLIB_GSETTINGS
GOBJECT_INTROSPECTION_REQUIRE([1.35.9])

AM_PROG_VALAC
VALA_CHECK_MODULES([DEPS], [gtk+-3.0])

AC_ARG_ENABLE(dogtail,
              [AS_HELP_STRING([--enable-dogtail],
                              [test using dogtail [default=yes]])],,
              enable_dogtail=yes)
AM_CONDITIONAL(ENABLE_DOGTAIL, test "$enable_dogtail" != no)
# coverage
AC_ARG_ENABLE([coverage],
              [AS_HELP_STRING([--enable-coverage],
                              [enable code coverage])],
              , [enable_coverage=no])
if test x$enable_coverage = xyes; then
    if test x$GCC != xyes; then
        AC_MSG_ERROR([GCC is required for --enable-coverage])
    fi

    AC_PATH_TOOL([LCOV], [lcov])
    AC_PATH_TOOL([GENHTML], [genhtml])

    if test x$LCOV = x || test x$GENHTML = x; then
        AC_MSG_ERROR([lcov and genhtml are required for --enable-coverage])
    fi

    # only enable these if we ever want code coverage for libgd
    # (which we don't)
    #CFLAGS="$CFLAGS -g -O0 --coverage"
    #CXXFLAGS="$CXXFLAGS -g -O0 --coverage"
    #LIBS="$LIBS -lgcov"
fi
AM_CONDITIONAL([ENABLE_COVERAGE], [test x$enable_coverage = xyes])

GLIB_TESTS

GLIB_COMPILE_RESOURCES=`$PKG_CONFIG --variable glib_compile_resources gio-2.0`
AC_SUBST(GLIB_COMPILE_RESOURCES)

AC_CONFIG_FILES([
  Makefile
  data/Makefile
  data/icons/Makefile
  src/Makefile
  tests/Makefile
  po/Makefile.in
])
AC_OUTPUT
