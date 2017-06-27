# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/hunter-packages/libjson-rpc-cpp.git"
EGIT_BRANCH=hunter
inherit cmake-utils git-r3

DESCRIPTION="Hunter compatible fork of JSON-RPC (1.0 & 2.0) framework for C++"
HOMEPAGE="https://github.com/hunter-packages/libjson-rpc-cpp"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +http-client +http-server +stubgen test"

RDEPEND="
	dev-libs/jsoncpp:=
	http-client? ( net-misc/curl:= )
	http-server? ( net-libs/libmicrohttpd:= )
	stubgen? ( dev-libs/argtable:= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/catch )"

RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DHTTP_CLIENT=$(usex http-client)
		-DHTTP_SERVER=$(usex http-server)
		# they are not installed
		-DCOMPILE_EXAMPLES=OFF
		-DCOMPILE_STUBGEN=$(usex stubgen)
		-DCOMPILE_TESTS=$(usex test)
		-DCATCH_INCLUDE_DIR="${EPREFIX}/usr/include/catch"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && emake -C "${BUILD_DIR}" doc
}

src_install() {
	cmake-utils_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doc/html
}
