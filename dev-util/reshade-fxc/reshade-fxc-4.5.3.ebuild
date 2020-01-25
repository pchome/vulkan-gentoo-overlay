# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="The ReShade FX shader compiler"
HOMEPAGE="https://github.com/crosire/reshade"
SRC_URI="https://github.com/crosire/reshade/archive/v${PV}.tar.gz -> reshade-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND=">=dev-util/reshade-fx-${PV}"
RDEPEND=""
BDEPEND="${DEPEND}"

S="${WORKDIR}/reshade-${PV}"

src_configure() {
	cp "${FILESDIR}/meson.build" ${S}/
	cp "${FILESDIR}/version.h" ${S}/tools/

	meson_src_configure
}

src_install() {
	meson_src_install
}
