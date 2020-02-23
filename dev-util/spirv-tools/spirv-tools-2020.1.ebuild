# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-multilib cmake-utils python-any-r1

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"
#EGIT_COMMIT="1b3441036a8f178cb3b41c1aa222b652db522a88"
#SRC_URI="https://github.com/KhronosGroup/SPIRV-Tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/KhronosGroup/SPIRV-Tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
# Tests fail upon finding symbols that do not match a regular expression
# in the generated library. Easily hit with non-standard compiler flags
RESTRICT="test"

COMMON_DEPEND=">=dev-util/spirv-headers-1.5.1"
DEPEND="${COMMON_DEPEND}"
RDEPEND=""
BDEPEND="${PYTHON_DEPS}
	${COMMON_DEPEND}"

#S="${WORKDIR}/SPIRV-Tools-${EGIT_COMMIT}"
S="${WORKDIR}/SPIRV-Tools-${PV}"

multilib_src_configure() {
	local mycmakeargs=(
		"-DSPIRV-Headers_SOURCE_DIR=/usr/"
		"-DSPIRV_WERROR=OFF"
	)

	cmake-utils_src_configure
}

#multilib_src_install() {
#	cmake-utils_src_install
#	echo "${EGIT_COMMIT}" > "${PN}-commit.h" || die
#	insinto /usr/include/"${PN}"
#	doins  "${PN}-commit.h"
#}
