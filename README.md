# AllStarLink Nodelist Updater
This package maintains the file-based node lookup database
located at `/var/lib/asterisk/rpt_extnodes`. This replaces,
and conflicts with, the asl-update-node-list package for
ASL2. Use one or the other, but not both.

The package does not enable `asl3-update-nodelist.timer`. It is
only needed when `node_lookup_method` in `/etc/asterisk/rpt.conf`
is `file` (or `both`); with `dns` it has nothing to do. To use it:

```bash
systemctl enable --now asl3-update-nodelist.timer
```

Once enabled, it updates the database every 3 to 5 minutes.
Each run downloads the list compressed, and only when it has
changed since the last download.

## Resetting Database State
To reset after a suspected database corruption:

```bash
rm -f /var/lib/asterisk/rpt_extnodes /var/lib/asterisk/asl3un-lastmod
touch /var/lib/asterisk/rpt_extnodes
chmod 644 /var/lib/asterisk/rpt_extnodes
chown asterisk:asterisk /var/lib/asterisk/rpt_extnodes
```

## Customizing the Timer
To customize the timer, copy `/lib/systemd/system/asl3-update-nodelist.timer`
to `/etc/systemd/system/asl3-update-nodelist.timer`. Then edit
the `OnBootSec=` and `OnUnitInactiveSec=` attributes for the desired timing.
Following the edit, execute `systemctl daemon-reload`.

```bash
cp /lib/systemd/system/asl3-update-nodelist.timer /etc/systemd/system/asl3-update-nodelist.timer
vi /etc/systemd/system/asl3-update-nodelist.timer
systemctl daemon-reload
```

## "astdb.txt" Updater
This package also maintains the file-based node information
database located at `/var/lib/asterisk/astdb.txt`. This replaces,
and conflicts with, the astdb.php command (and cron/daily jobs)
used in older/other versions of ASL.

On installation of the package, the `asl3-update-astdb.timer`
is disabled.  When enabled, the database will be updated 4x/day.

To enable this updater, use:

```bash
systemctl enable asl3-update-astdb.service
systemctl enable asl3-update-astdb.timer
systemctl start asl3-update-astdb.timer
```

