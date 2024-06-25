% asl3-update-astdb(1) asl3-update-astdb 1.0

# NAME
asl3-update-astdb - Creates (or updates) the AllStarLink node information database 

# SYNOPSIS
Usage: asl3-update-astdb 

# DESCRIPTION
The **asl3-update-astdb** command downloads the AllStarLink node information
database file to `/var/lib/asterisk/astdb.txt`.

The database is used by some web applications to provide additional
information about connected nodes. The database includes the callsign,
frequency, and location for each registered node.

The command is normally executed using the systemd asl3-update-astdb.service
and asl3-update-astdb.timer. The command can be run by hand but only
as the "root" user.

NOTE: by default, both the service and timer are disabled.  If you are
installing one of the web applications that uses the "astdb.txt" file
then you will want to enable (and start) them using:
```bash
systemctl enable asl3-update-astdb.service
systemctl enable asl3-update-astdb.timer
systemctl start asl3-update-astdb.timer
```

# BUGS
Report bugs to https://github.com/AllStarLink/asl3-update-nodelist/issues

# COPYRIGHT
Copyright (C) 2016 - 2024 AllStarLink under the terms of GPL v3.
