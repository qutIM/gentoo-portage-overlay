# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils qt4

EGIT_REPO_URI="http://github.com/proDOOMman/${PN}.git"
DESCRIPTION="OTR crypto plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

DEPEND="net-im/qutim:${SLOT}
        net-libs/libotr
        !x11-plugins/${PN}:0.2
        !x11-plugins/${PN}:live"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
	fi
}


src_compile() {
	eqmake4 ${MY_PN}.pro || die "configure plugin failed"
	emake || die "make plugin failed"
}

src_install() {
	insinto /usr/$(get_libdir)/qutim
	doins "${S}/lib${MY_PN}.so" || die "Plugin installation failed"
}
