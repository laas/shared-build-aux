#                                                                -*-Automake-*-
# Copyright (C) 2009 by Thomas Moulard, AIST, CNRS, INRIA.
# This file is part of the roboptim.
#
# roboptim is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Additional permission under section 7 of the GNU General Public
# License, version 3 ("GPLv3"):
#
# If you convey this file as part of a work that contains a
# configuration script generated by Autoconf, you may do so under
# terms of your choice.
#
# roboptim is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with roboptim.  If not, see <http://www.gnu.org/licenses/>.

# -------#
# README #
# -------#

# This file contains pkg-config generation rules for Automake.
#
# This file assumes that:
#
# - you include *before* this file init.mk or make sure that any global
# variable can be used with the += syntax.
# - there is no other rule using install-data-local and uninstall-data-local.
#
# The generate pkg-config files can be customized using three Autoconf
# variables:
# - PKGCONFIG_REQUIRES: package dependencies,
# - PKGCONFIG_LIBS: package LDFLAGS,
# - PKGCONFIG_CFLAGS: package CFLAGS/CPPFLAGS/CXXFLAGS.


# Variables
pkg_config_file = '@PACKAGE_TARNAME@.pc'
pkgdir = "$(DESTDIR)$(libdir)/pkgconfig/"

EXTRA_DIST += build-aux/pkg-config.pc.in
CLEANFILES += $(pkg_config_file)

# pkg-config generation.
@PACKAGE_TARNAME@.pc: $(srcdir)/build-aux/pkg-config.pc.in
	$(top_builddir)/config.status \
	--file="$@":"$(srcdir)/build-aux/pkg-config.pc.in"

# Install, uninstall rules.
install-data-local: install-pkg-config
uninstall-local: uninstall-pkg-config

install-pkg-config: $(PACKAGE_TARNAME).pc
	$(mkdir_p) $(pkgdir)
	$(install_sh_DATA) $(pkg_config_file) $(pkgdir)

uninstall-pkg-config:
	-rm -f "$(pkgdir)$(pkg_config_file)"

# Check that the pkg-config file is generated.
check-local: @PACKAGE_TARNAME@.pc
	@if ! test -f $(pkg_config_file); then			\
		echo 'pkg-config file missing: failing...';	\
		return 1;					\
	else							\
		echo 'pkg-config file has been generated: ok.';	\
	fi
