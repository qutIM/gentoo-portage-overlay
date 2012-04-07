# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit flag-o-matic cmake-utils

DESCRIPTION="Plugins for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

SRC_URI="http://www.qutim.org/dwnl/TODO/qutim-${PV}.tar.bz2"
S="${WORKDIR}/qutim-${PV}"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"

PLUGINS_STABLE="aescrypto aspeller clconf +dbus dbusnotify emoedit floaties \
	histman hunspeller +kineticpopups kde massmessaging phonon sdl \
	scriptapi +unreadmessageskeeper weather"
PLUGINS_UNSTABLE="antiboss antispam awn birthdayreminder indicator nowplaying \
	qmlchat urlpreview yandexnarod"

IUSE="${PLUGINS_STABLE} ${PLUGINS_UNSTABLE} debug"

RDEPEND="net-im/qutim:${SLOT}
	aescrypto? ( app-crypt/qca )
	aspeller? ( app-text/aspell )
	awn? ( x11-libs/qt-dbus
		   gnome-extra/avant-window-navigator )
	dbus? ( >=x11-libs/qt-dbus-4.6.0 )
	dbusnotify? ( >=x11-libs/qt-dbus-4.6.0 )
	histman? ( x11-libs/qt-sql )
	hunspeller? ( app-text/hunspell )
	indicator? ( dev-libs/libindicate-qt )
	kineticpopups? ( >=x11-libs/qt-declarative-4.7.2 )
	qmlchat? ( >=x11-libs/qt-declarative-4.7.2 )
	sdl? ( media-libs/sdl-mixer )
	phonon? ( media-libs/phonon )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	dev-util/pkgconfig"

PDEPEND="kde? ( kde-misc/qutim-kdeintegration:${SLOT}[debug?] )"

RESTRICT="debug? ( strip )"

CMAKE_USE_DIR="${S}/plugins"
CMAKE_IN_SOURCE_BUILD=1

pkg_pretend() {
	local unstable
	for unstable in ${PLUGINS_UNSTABLE} ; do
		use "${unstable}" && ewarn "WARNING: You have enabled the build of the
		${unstable} plugin which is known to be not working for now"
	done
}

src_configure() {
	if use debug ; then
		filter-flags -O* -f*
		append-flags -O1 -g -ggdb
	fi

	mycmakeargs=(
		-DQUTIM_ENABLE_ALL_PLUGINS=off
		$(cmake-utils_use aescrypto AESCRYPTO)
		$(cmake-utils_use antiboss ANTIBOSS)
		$(cmake-utils_use antispam ANTISPAM)
		$(cmake-utils_use aspell ASPELLER)
		$(cmake-utils_use awn AWN)
		$(cmake-utils_use birthdayreminder BIRTHDAYREMINDER)
		$(cmake-utils_use clconf CLCONF)
		$(cmake-utils_use dbus DBUSAPI)
		$(cmake-utils_use dbusnotify DBUSNOTIFICATIONS)
		$(cmake-utils_use emoedit EMOEDIT)
		$(cmake-utils_use floaties FLOATIES)
		$(cmake-utils_use histman HISTMAN)
		$(cmake-utils_use hunspell HUNSPELLER)
		$(cmake-utils_use indicator INDICATOR)
		$(cmake-utils_use kineticpopups KINETICPOPUPS)
		$(cmake-utils_use kineticpopups QUICKPOPUP/DEFAULT)
		$(cmake-utils_use kineticpopups QUICKPOPUP/GLASS)
		$(cmake-utils_use massmessaging MASSMESSAGING)
		$(cmake-utils_use nowplaying NOWPLAYING)
		$(cmake-utils_use phonon PHONONSOUND)
		$(cmake-utils_use qmlchat QMLCHAT)
		$(cmake-utils_use qmlchat QMLCHAT/DEFAULT)
		$(cmake-utils_use sdl SDLSOUND)
		$(cmake-utils_use scriptapi SCRIPTAPI)
		$(cmake-utils_use unreadmessageskeeper UNREADMESSAGESKEEPER)
		$(cmake-utils_use urlpreview URLPREVIEW)
		$(cmake-utils_use weather WEATHER)
		$(cmake-utils_use yandexnarod YANDEXNAROD)
	)
	cmake-utils_src_configure
}
