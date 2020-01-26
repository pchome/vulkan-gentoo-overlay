# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/LunarG/VulkanTools.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/LunarG/VulkanTools/archive/sdk-${PV}.tar.gz -> VulkanTools-sdk-${PV}.tar.gz"
	S="${WORKDIR}/VulkanTools-sdk-${PV}"
fi

inherit python-any-r1 cmake-utils

DESCRIPTION="Vulkan Configurator"
HOMEPAGE="https://github.com/LunarG/VulkanTools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="X wayland"

DEPEND="${PYTHON_DEPS}
	dev-util/vulkan-headers
	media-libs/vulkan-loader:=[wayland?,X?]
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libXrandr
	)"

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_TESTS=OFF
		-DBUILD_LAYERSVT=OFF
		-DBUILD_VKTRACE=OFF
		-DBUILD_VIA=OFF
		-DBUILD_VLF=OFF
		-DBUILD_LAYERMGR=ON
		-DBUILD_VKTRACE_REPLAY=OFF
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_LOADER_INSTALL_DIR="/usr"
		-DVULKAN_VALIDATIONLAYERS_INSTALL_DIR="/usr"
		-DVULKAN_HEADERS_INSTALL_DIR="/usr"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	[ ! -d "${ED}/usr/share/vulkan" ] && mv "${ED}/usr/etc/vulkan" "${ED}/usr/share/"
	rm -r "${ED}/usr/etc"
}
