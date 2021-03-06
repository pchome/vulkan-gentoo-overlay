# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-ValidationLayers.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	EGIT_COMMIT="ac02c61ffc63cab94f5272528561a0c801f76486"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-ValidationLayers-${EGIT_COMMIT}"
fi

inherit python-any-r1 cmake-multilib

DESCRIPTION="Vulkan Validation Layers"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-ValidationLayers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="X wayland"

DEPEND="${PYTHON_DEPS}
		>=dev-util/glslang-7.12.3353_pre20191027-r1:=[${MULTILIB_USEDEP}]
		~dev-util/spirv-tools-2020.01_pre20200125:=[${MULTILIB_USEDEP}]
		>=dev-util/vulkan-headers-${PV}
		wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
		X? (
		   x11-libs/libX11:=[${MULTILIB_USEDEP}]
		   x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
		   )"

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_LAYER_SUPPORT_FILES=True
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DBUILD_TESTS=False
		-DGLSLANG_INSTALL_DIR="/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="/usr/include/vulkan/"
	)
	cmake-utils_src_configure
}
