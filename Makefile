#
# Build variables
#
SRCNAME = asl3-update-nodelist
PKGNAME = $(SRCNAME)
RELVER = 1.5.0
DEBVER = 1
RELPLAT ?= deb$(shell lsb_release -rs 2> /dev/null)

#
# Other variables
#
prefix ?= /usr
bindir ?= $(prefix)/bin
systemd_enabled_dir ?= /lib/systemd/system
systemd_disabled_dir ?= /etc/systemd/system
mandir ?= $(prefix)/share/man

BIN_FILES = \
	asl3-update-astdb \
	asl3-update-nodelist

SYSTEMD_ENABLED_FILES = \
	asl3-update-nodelist.service \
	asl3-update-nodelist.timer

SYSTEMD_DISABLED_FILES = \
	asl3-update-astdb.service \
	asl3-update-astdb.timer

MAN_FILES = \
	asl3-update-astdb.1.md \
	asl3-update-nodelist.1.md

BIN_INSTALLABLES = $(patsubst %, $(DESTDIR)$(bindir)/%, $(BIN_FILES))
SYSTEMD_ENABLED_INSTALLABLES = $(patsubst %, $(DESTDIR)$(systemd_enabled_dir)/%, $(SYSTEMD_ENABLED_FILES))
SYSTEMD_DISABLED_INSTALLABLES = $(patsubst %, $(DESTDIR)$(systemd_disabled_dir)/%, $(SYSTEMD_DISABLED_FILES))
MAN_INSTALLABLES = $(patsubst %.md, $(DESTDIR)$(mandir)/man1/%, $(MAN_FILES))
INSTALLABLES = $(BIN_INSTALLABLES) $(SYSTEMD_ENABLED_INSTALLABLES) $(SYSTEMD_DISABLED_INSTALLABLES) $(MAN_INSTALLABLES)


default:
	@echo This does nothing 

install: $(INSTALLABLES)

$(DESTDIR)$(bindir)/%: %
	install -D -m 0755  $< $@

$(DESTDIR)$(systemd_enabled_dir)/%: %
	install -D -m 0644  $< $@

$(DESTDIR)$(systemd_disabled_dir)/%: %
	install -D -m 0644  $< $@

$(DESTDIR)$(mandir)/man1/%: %.md
	mkdir -p $(DESTDIR)$(mandir)/man1
	pandoc $< -s -t man > $@


deb:	debclean debprep
	debchange --distribution stable --package $(PKGNAME) \
		--newversion $(EPOCHVER)$(RELVER)-$(DEBVER).$(RELPLAT) \
		"Autobuild of $(EPOCHVER)$(RELVER)-$(DEBVER) for $(RELPLAT)"
	dpkg-buildpackage -b --no-sign
	git checkout debian/changelog

debchange:
	debchange -v $(RELVER)-$(DEBVER)
	debchange -r


debprep:	debclean
	(cd .. && \
		rm -f $(PKGNAME)-$(RELVER) && \
		rm -f $(PKGNAME)-$(RELVER).tar.gz && \
		rm -f $(PKGNAME)_$(RELVER).orig.tar.gz && \
		ln -s $(SRCNAME) $(PKGNAME)-$(RELVER) && \
		tar --exclude=".git" -h -zvcf $(PKGNAME)-$(RELVER).tar.gz $(PKGNAME)-$(RELVER) && \
		ln -s $(PKGNAME)-$(RELVER).tar.gz $(PKGNAME)_$(RELVER).orig.tar.gz )

debclean:
	rm -f ../$(PKGNAME)_$(RELVER)*
	rm -f ../$(PKGNAME)-$(RELVER)*
	rm -rf debian/$(PKGNAME)
	rm -f debian/files
	rm -rf debian/.debhelper/
	rm -f debian/debhelper-build-stamp
	rm -f debian/*.substvars
	rm -rf debian/$(SRCNAME)/ debian/.debhelper/
	rm -f debian/debhelper-build-stamp debian/files debian/$(SRCNAME).substvars
	rm -f debian/*.debhelper

	
