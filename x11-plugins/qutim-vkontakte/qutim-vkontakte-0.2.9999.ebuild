# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils qt4

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="Vkontakte social network plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

DEPEND="net-im/qutim:${SLOT}
        !x11-plugins/qutim-vkontakte:0.2
        !x11-plugins/qutim-vkontakte:live"

RESTRICT="debug? ( strip )"

MY_PN=${S#qutim-}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	S="${S}/${MY_PN}"
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
	fi
}


src_compile() {
	eqmake4 vkontakte.pro || die "configure Vkontakte plugin failed"
	emake || die "make Vkontakte plugin failed"
}

src_install() {
	insinto /usr/$(get_libdir)/qutim
	doins "${S}/libvkontakte.so" || die "Plugin installation failed"
}
