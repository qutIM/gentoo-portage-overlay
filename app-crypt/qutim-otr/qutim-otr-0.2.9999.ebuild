# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 eutils qt4-r2

EGIT_REPO_URI="git://github.com/proDOOMman/${PN}.git"
DESCRIPTION="OTR crypto plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""
IUSE="debug"

DEPEND="net-im/qutim:${SLOT}
	net-libs/libotr"

RDEPEND=${DEPEND}

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
		sed -e "/include/s/<qutim\//<qutim-${PV}\//" -i ${i};
	done
	sed -e "s/qutim\/protocol/qutim-${PV}\/protocol/" -i smpdialog.h
}

src_compile() {
	eqmake4 ${MY_PN}.pro || die "configure plugin failed"
	emake || die "make plugin failed"
}

src_install() {
	insinto "/usr/$(get_libdir)/qutim-${PV}"
	doins "${S}/lib${MY_PN}.so" || die "Plugin installation failed"
}
