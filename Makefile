# Override the arch with `make ARCH=i386`
ARCH ?= $(shell flatpak --default-arch)
REPO ?= repo

all: build install-repo
	flatpak update --user io.atom.electron.BaseApp

build: ${REPO} 
	flatpak-builder --force-clean --ccache --require-changes --repo=${REPO} --arch=${ARCH} \
		--subject="build of io.atom.electron.BaseApp, `date`" \
		${EXPORT_ARGS} build io.atom.electron.BaseApp.json

${REPO}:
	ostree  init --mode=archive-z2 --repo=${REPO}

# Convenience to install deps. Require flatpak > 0.6.13.
# If you already have a gnome remote just install from that!
install-deps:
	flatpak --user remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo
	flatpak --user install gnome org.freedesktop.Platform/${ARCH}/1.6 org.freedesktop.Sdk/${ARCH}/1.6

install-repo:
	flatpak --user remote-add --if-not-exists --no-gpg-verify nightly-electron ./repo
	flatpak --user -v install nightly-electron io.atom.electron.BaseApp || true
