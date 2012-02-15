# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Plugins meta ebuild for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""

PLUGINS_GOOD="aescrypto aspeller clconf +dbus dbusnotify emoedit floaties \
	histman hunspeller +kineticpopups kde massmessaging phonon sdl \
	+unreadmessageskeeper weather"
PLUGINS_BAD="antiboss antispam awn birthdayreminder indicator nowplaying \
	qmlchat urlpreview yandexnarod"

IUSE="${PLUGINS_GOOD} ${PLUGINS_BAD} debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}"

PDEPEND="kde? ( kde-misc/qutim-kdeintegration:${SLOT}[debug?] )
	aescrypto? ( x11-plugins/qutim-aescrypto:${SLOT}[debug?] )
	antiboss? ( x11-plugins/qutim-antiboss:${SLOT}[debug?] )
	antispam? ( x11-plugins/qutim-antispam:${SLOT}[debug?] )
	aspeller? ( x11-plugins/qutim-aspeller:${SLOT}[debug?] )
	awn? ( x11-plugins/qutim-awn:${SLOT}[debug?] )
	birthdayreminder? ( x11-plugins/qutim-birthdayreminder:${SLOT}[debug?] )
	clconf? ( x11-plugins/qutim-clconf:${SLOT}[debug?] )
	dbus? ( x11-plugins/qutim-dbusapi:${SLOT}[debug?] )
	histman? ( x11-plugins/qutim-histman:${SLOT}[debug?] )
	hunspeller? ( x11-plugins/qutim-hunspeller:${SLOT}[debug?] )
	indicator? ( x11-plugins/qutim-indicator:${SLOT}[debug?] )
	massmessaging? ( x11-plugins/qutim-massmessaging:${SLOT}[debug?] )
	nowplaying? ( x11-plugins/qutim-nowplaying:${SLOT}[debug?] )
	qmlchat? ( x11-plugins/qutim-qmlchat:${SLOT}[debug?] )
	phonon? ( x11-plugins/qutim-phonon:${SLOT}[debug?] )
	unreadmessageskeeper? ( x11-plugins/qutim-unreadmessageskeeper:${SLOT}[debug?] )
	urlpreview? ( x11-plugins/qutim-urlpreview:${SLOT}[debug?] )
	weather? ( x11-plugins/qutim-weather:${SLOT}[debug?] )
	yandexnarod? ( x11-plugins/qutim-yandexnarod:${SLOT}[debug?] )
	sdl? ( x11-plugins/qutim-sdlsound:${SLOT}[debug?] )
	kineticpopups? ( x11-plugins/qutim-kineticpopups:${SLOT}[debug?] )"

RESTRICT="debug? ( strip )"

pre_src_unpack() {
	# Some Bash magick
	useArr=$(echo $USE | tr ";" "\n")
	for oneUse in $useArr
	do
	  if (has $oneUse $PLUGINS_BAD) ; then
	    ewarn "WARNING: You have enabled the build of the ${oneUse} plugin which is known to be not working for now"
	  fi
	done
}
