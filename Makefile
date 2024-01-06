#
# Build variables
#
SRCNAME = asl3-update-nodelist
PKGNAME = $(SRCNAME)
RELVER = 1.1
DEBVER = 2

#
# Other variables
#
prefix ?= /usr
bindir ?= $(prefix)/bin
sysddir ?= /lib/systemd/system
mandir ?= $(prefix)/share/man

BIN_FILES = \
	asl3-update-nodelist

SYSD_FILES = \
	asl3-update-nodelist.service \
	asl3-update-nodelist.timer

MAN_FILES = \
	asl3-update-nodelist.1.md

BIN_INSTALLABLES = $(patsubst %, $(DESTDIR)$(bindir)/%, $(BIN_FILES))
SYSD_INSTALLABLES = $(patsubst %, $(DESTDIR)$(sysddir)/%, $(SYSD_FILES))
MAN_INSTALLABLES = $(patsubst %.md, $(DESTDIR)$(mandir)/man1/%, $(MAN_FILES))
INSTALLABLES = $(BIN_INSTALLABLES) $(SYSD_INSTALLABLES) $(MAN_INSTALLABLES)


default:
	@echo This does nothing 

install: $(INSTALLABLES)

$(DESTDIR)$(bindir)/%: %
	install -D -m 0755  $< $@

$(DESTDIR)$(sysddir)/%: %
	install -D -m 0644  $< $@

$(DESTDIR)$(mandir)/man1/%: %.md
	mkdir -p $(DESTDIR)$(mandir)/man1
	pandoc $< -s -t man > $@


deb:	debclean debprep
	debuild

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

	
