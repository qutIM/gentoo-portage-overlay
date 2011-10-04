# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 eutils cmake-utils confutils

DESCRIPTION="Localization package for net-im/qutim"
HOMEPAGE="http://www.qutim.org"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
CMAKE_USE_DIR="${S}/translations"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""

IUSE="linguas_ru linguas_bg linguas_cs linguas_de linguas_uk"

EGIT_BRANCH="master"
EGIT_HAS_SUBMODULES="true"
EGIT_PROJECT="qutim-${SLOT}"

LANGUAGES=""

DEPEND=""
RDEPEND="${DEPEND}
	net-im/qutim:${SLOT}"

src_unpack() {
	git-2_src_unpack
}

src_compile() {
	CMAKE_IN_SOURCE_BUILD=1
	mycmakeargs=(
		$(cmake-utils_use linguas_ru LANGUAGES/RU_RU)
		$(cmake-utils_use linguas_bg LANGUAGES/BG_BG)
		$(cmake-utils_use linguas_cs LANGUAGES/CS_CZ)
		$(cmake-utils_use linguas_de LANGUAGES/DE_DE)
		$(cmake-utils_use linguas_uk LANGUAGES/UK_UA)
	)
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	ewarn
	ewarn "If localization doesn't appear for you, change \"shareDir\" value"
	ewarn "in .config/qutim/profiles/profiles.json to \"/usr/share/qutim\""
	ewarn
}
