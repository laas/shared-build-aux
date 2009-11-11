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

# ------- #
# CAUTION #
# ------- #

# Currently, I do not know how to build rpms *locally*.
# You will have to know what is your RPM building directory
# (see rpmbuild documentation).
# Set RPM_TREE to this directory. You will need write access
# to this directory.
# Hint:
# - on Gentoo RPM_TREE is ``/usrc/src/rpm''
# - on Red Hat ``/usr/src/redhat''
# - on Fedora ``$HOME/rpmbuild''

RPMBUILD = rpmbuild

SPECFILE = @PACKAGE_TARNAME@.spec
EXTRA_DIST += @PACKAGE_TARNAME@.spec.in

# Files to be removed by cleaning rule.
CLEANFILES +=				\
	$(SPECFILE)


.PHONY: install-rpm install-rpm-tree install-rpm-tarball src-rpm rpm

# Do nothing by default.
all:

install-rpm: install-rpm-tree install-rpm-tarball

# Prepare tree.
install-rpm-tree:
	@if test "x$$RPM_TREE" = "x"; then	\
	  echo "Please define RPM_TREE.";	\
          exit 1;				\
	fi
	$(mkdir_p) $$RPM_TREE/BUILD
	$(mkdir_p) $$RPM_TREE/RPMS
	$(mkdir_p) $$RPM_TREE/SOURCES
	$(mkdir_p) $$RPM_TREE/SPECS
	$(mkdir_p) $$RPM_TREE/SRPMS

install-rpm-tarball:
	@if test "x$$RPM_TREE" = "x"; then	\
	  echo "Please define RPM_TREE.";	\
          exit 1;				\
	fi
	cd $(top_builddir) && $(MAKE) $(AM_MAKEFLAGS) dist-gzip
	cp $(top_builddir)/$(PACKAGE)-$(VERSION).tar.gz $$RPM_TREE/SOURCES

# Build source RPM
src-rpm: install-rpm $(SPECFILE)
	$(RPMBUILD) -bs $(SPECFILE)

# Build binary RPM
rpm: install-rpm $(SPECFILE)
	$(RPMBUILD) -bb $(SPECFILE)

# Generate spec file.
@PACKAGE_TARNAME@: @PACKAGE_TARNAME@.in
	$(top_builddir)/config.status --file="$@":"$<"
