# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib cmake-utils

DESCRIPTION="Perform reflection on SPIR-V and disassembling SPIR-V back to high level languages"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Cross"

GH_VER="$(ver_cut 1)-$(ver_cut 2)-$(ver_cut 3)"
SRC_URI="https://github.com/KhronosGroup/SPIRV-Cross/archive/${GH_VER}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

DEPEND=">=dev-util/spirv-headers-1.5.1"
RDEPEND=""
BDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-respect-libdir.patch" )

S="${WORKDIR}/SPIRV-Cross-${GH_VER}"

multilib_src_configure() {
	local mycmakeargs=(
		"-DSPIRV_CROSS_ENABLE_TESTS=OFF"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
}
