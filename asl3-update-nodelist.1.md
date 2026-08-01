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

The command reads `node_lookup_method` from `/etc/asterisk/rpt.conf`
directly (not from `#include` or `#tryinclude` files) and adjusts
its behavior:

**dns**
:   Exits without downloading. app_rpt does not consult `rpt_extnodes`.

**file**
:   Downloads on every invocation.

**both**
:   DNS is tried first by app_rpt and `rpt_extnodes` is used only as
    failover. When DNS is healthy and `rpt_extnodes` was modified within
    the last 24 hours, the command exits without downloading. The throttle
    is bypassed when the file is missing, older than 24 hours, or DNS
    probing fails.

# ENVIRONMENT

**BOTH_UPDATE_INTERVAL**
:   Seconds between throttled updates in `both` mode (default 86400).
    DNS health is checked with an SOA query for `dns_node_domain`
    (or `nodes.allstarlink.org` if unset).

This variable may be set in the service unit environment. Use
**systemctl edit asl3-update-nodelist.service** to add override lines such as:

```ini
[Service]
Environment=BOTH_UPDATE_INTERVAL=43200
```

Do not edit `/usr/bin/asl3-update-nodelist` to change this value.

The command is normally executed using asl3-update-nodelist.timer
from systemd. It can be run by hand but only as the asterisk
user or else problems will occur!!

# BUGS
Report bugs to https://github.com/AllStarLink/asl3-update-nodelist/issues

# COPYRIGHT
Copyright (C) 2017 - 2025 AllStarLink under the terms of GPL v3.


