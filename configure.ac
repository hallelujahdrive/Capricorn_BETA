#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([capricorn],[beta-1.0], [halleluajhdrive@gmail.com])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([foreign])



# Checks for programs.
LT_PREREQ([2.4.2])
LT_INIT
AC_PROG_CC
AC_PROG_CC_STDC
AM_PROG_VALAC([0.26])
AC_PROG_INSTALL
#IT_PROG_INTLTOOL([0.50])

# Checks for libraries.
pkg_modules="
	cairo
	gdk-3.0
	glib-2.0
	gtk+-3.0
	libsoup-2.4
	pango
  ruribitaki
	sqlite3
	"

pkg_version="
	gtk>=3.10
"

PKG_CHECK_MODULES(CPR,[$pkg_modules],[$pkg_version])

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
CPR_VALA_FLAGS=" \
	--pkg cairo \
	--pkg gdk-3.0 \
	--pkg glib-2.0 \
	--pkg gmodule-2.0 \
	--pkg gtk+-3.0 \
	--pkg json-glib-1.0 \
	--pkg libsoup-2.4 \
	--pkg pango \
	--pkg rest-0.7 \
  --pkg ruribitaki \
	--pkg sqlite3 \
	--target-glib=2.38 \
	--gresources=\$(top_srcdir)/gresources.xml
"
bindir=${prefix}/bin
datadir=${prefix}/share
prefix=${prefix}/local

AC_SUBST(CPR_CFLAGS)
AC_SUBST(CPR_LIBS)
AC_SUBST(CPR_VALA_FLAGS)
AC_SUBST(bindir)
AC_SUBST(datadir)
AC_SUBST(prefix)

AC_CHECK_FUNCS([atexit memchr memset setlocale strstr])

AC_CONFIG_FILES([Makefile
								 data/Makefile
								 icons/16x16/actions/Makefile
								 icons/24x24/actions/Makefile
                 icons/48x48/actions/Makefile
								 icons/128x128/apps/Makefile
								 icons/16x16/apps/Makefile
								 icons/22x22/apps/Makefile
								 icons/24x24/apps/Makefile
								 icons/256x256/apps/Makefile
								 icons/32x32/apps/Makefile
								 icons/48x48/apps/Makefile
								 icons/64x64/apps/Makefile
                 icons/128x128/Makefile
                 icons/16x16/Makefile
                 icons/22x22/Makefile
                 icons/24x24/Makefile
                 icons/256x256/Makefile
                 icons/32x32/Makefile
                 icons/48x48/Makefile
                 icons/64x64/Makefile
                 icons/Makefile
                 src/Makefile
                 ui/Makefile
								 data/capricorn.desktop
								 src/utils/DirPath.vala])

AC_PATH_PROG(GLIB_COMPILE_RESOURCES,glib-compile-resources)

AC_OUTPUT
