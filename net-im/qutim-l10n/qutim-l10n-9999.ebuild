# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

unset _live_inherits

if [[ ${PV} == *9999* ]]; then
	EGIT_BRANCH="master"
	EGIT_HAS_SUBMODULES="true"
	EGIT_PROJECT="qutim"
	EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
	_live_inherits=git-2
else
	SRC_URI="http://qut.im/dwnl/34/qutim-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

inherit flag-o-matic cmake-utils ${_live_inherits}

DESCRIPTION="Localization package for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

LANGS="ru bg cs de uk"
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

DEPEND="net-im/qutim:${SLOT}"

CMAKE_USE_DIR="${S}/translations"
CMAKE_IN_SOURCE_BUILD=1

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use linguas_ru LANGUAGES/RU_RU)
		$(cmake-utils_use linguas_bg LANGUAGES/BG_BG)
		$(cmake-utils_use linguas_cs LANGUAGES/CS_CZ)
		$(cmake-utils_use linguas_de LANGUAGES/DE_DE)
		$(cmake-utils_use linguas_uk LANGUAGES/UK_UA)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	ewarn
	ewarn "If localization doesn't appear for you, change \"shareDir\" value"
	ewarn "in .config/qutim/profiles/profiles.json to \"/usr/share/qutim\""
	ewarn
}
