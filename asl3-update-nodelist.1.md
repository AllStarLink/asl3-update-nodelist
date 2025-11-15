% asl3-update-nodelist(1) asl3-update-nodelist 1.0
% Jason McCormick
% November 2025

# NAME
asl3-update-nodelist - Creates (or updates) the AllStarLink node connection database 

# SYNOPSIS
usage: asl3-update-nodelist 

# DESCRIPTION
**asl3-update-nodelist** downloads the AllStarLink node database file
to `/var/lib/asterisk/rpt_extnodes` using the full/diff/empty
strategy offered by `https://snodes.allstarlink.org/diffnodes.php`.
It will only act if node\_lookup\_method is not "dns" in
/etc/asterisk/rpt.conf. Otherwise it will exit without error.

The command is normally executed using asl3-update-nodelist.timer
from systemd. It can be run by hand but only as the asterisk
user or else problems will occur!!

# BUGS
Report bugs to https://github.com/AllStarLink/asl3-update-nodelist/issues

# COPYRIGHT
Copyright (C) 2017 - 2025 AllStarLink under the terms of GPL v3.


