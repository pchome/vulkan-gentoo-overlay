# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Post-processing shaders written in the ReShade FX shader language"
HOMEPAGE="https://github.com/crosire/reshade-shaders"

PV_COMMIT=695d831405041b609e97481ecb0c1759e07cb781
SRC_URI="https://github.com/crosire/reshade-shaders/archive/${PV_COMMIT}.zip -> reshade-shaders-${PV}.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

S="${WORKDIR}/reshade-shaders-${PV_COMMIT}"

src_install() {
	insinto "/usr/share/${PN}"

	doins -r "${S}/Shaders"
	doins -r "${S}/Textures"

	dodoc "${S}/REFERENCE.md"
	dodoc "${S}/README.md"
}
