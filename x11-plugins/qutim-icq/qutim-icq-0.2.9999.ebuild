# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git eutils qt4

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim-protocols"
DESCRIPTION="ICQ protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""
IUSE="debug"

DEPEND="net-im/qutim:${SLOT}"

RESTRICT="debug? ( strip )"

MY_PN="oscar"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	S="${S}/${MY_PN}"
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
	fi
	sed -e "s/qutim/qutim-${PV}/" -i "${S}/icq.pro"

	for i in $(grep -ril "<qutim/" "${S}" | grep -v "\.git"); do
		sed -e "s/<qutim\//<qutim-${PV}\//" -i ${i};
	done
}

src_compile() {
	eqmake4 icq.pro || die "Failed ICQ plugin configure"
	emake || die "Failed ICQ plugin build"
}

src_install() {
	insinto /usr/$(get_libdir)/qutim-${PV}
	doins "${S}/lib${MY_PN}.so" || die "Plugin installation failed"
}
