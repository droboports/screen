### NCURSES ###
_build_ncurses() {
local VERSION="5.9"
local FOLDER="ncurses-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://ftp.gnu.org/gnu/ncurses/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd target/"${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" \
  --libdir="${DEST}/lib" --datadir="${DEST}/share" \
  --with-shared --enable-rpath
make
make install
rm -v "${DEST}/lib"/*.a
popd
}

### SCREEN ###
_build_screen() {
local VERSION="4.3.1"
local FOLDER="screen-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://ftp.gnu.org/gnu/screen/${FILE}"
local SRC="${PWD}/src"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd target/"${FOLDER}"
# see http://savannah.gnu.org/bugs/?43222
# and http://savannah.gnu.org/bugs/?43223
# for the patch explanations.
for p in ${SRC}/*.patch; do
  patch -p1 -i "${p}"
done
./autogen.sh
./configure --host="${HOST}" --prefix="${DEST}" --mandir="${DEST}/man" \
  --with-pty-mode=0620 --with-pty-group=0 \
  --disable-socket-dir --enable-colors256 \
  --with-sys-screenrc="${DEST}/etc/screenrc"
make
make install
mkdir -p "${DEST}/etc"
cp -v etc/etcscreenrc "${DEST}/etc/screenrc"
cp -v etc/screenrc "${DEST}/etc/.screenrc"
popd
}

### BUILD ###
_build() {
  _build_ncurses
  _build_screen
  _package
}
