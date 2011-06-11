# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 eutils qt4-r2

EGIT_REPO_URI="git://gitorious.org/vsqlhistory/vsqlhistory.git"
DESCRIPTION="V-SQL storage history plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""
IUSE="debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}
	!x11-plugins/qutim-sqlhistory
	!x11-plugins/qutim-webhistory"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
	fi
	for i in $(grep -rl "<qutim/" "${S}" | grep -v "\.git"); do
		sed -e "s/<qutim\//<qutim-${PV}\//" -i ${i};
	done
}

src_compile() {
	eqmake4 sqlhistory.pro || die "Failed plugin configure"
	emake || die "Failed plugin build"
}

src_install() {
	mv libsqlhistory.so "lib${MY_PN}.so"
	insinto "/usr/$(get_libdir)/qutim-${PV}"
	doins "${S}/lib${MY_PN}.so" || die "Plugin installation failed"
}
