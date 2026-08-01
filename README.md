# AllStarLink Nodelist Updater
This package maintains the file-based node lookup database
located at `/var/lib/asterisk/rpt_extnodes`. This replaces,
and conflicts with, the asl-update-node-list package for
ASL2. Use one or the other, but not both.

On installation of the package, the `asl3-update-nodelist.timer`
is not enabled automatically. When enabled, it updates the database
every 180 seconds using the full/differential method.

### node_lookup_method behavior

The updater reads `node_lookup_method` from `/etc/asterisk/rpt.conf`
and adjusts its behavior accordingly:

| Method | Behavior |
|--------|----------|
| `dns` | Skips updates; `rpt_extnodes` is not consulted by app_rpt |
| `file` | Updates on every timer run |
| `both` | Skips updates when DNS is healthy and `rpt_extnodes` was refreshed within the last 24 hours; updates when DNS is unavailable or the file is older than 24 hours |

The throttle interval can be overridden with `BOTH_UPDATE_INTERVAL`
(see `asl3-update-nodelist(1)`).

To enable the nodelist updater:

```bash
systemctl enable asl3-update-nodelist.timer
systemctl start asl3-update-nodelist.timer
```

## Customizing throttle settings

When `node_lookup_method = both`, override `BOTH_UPDATE_INTERVAL` with:

```bash
systemctl edit asl3-update-nodelist.service
```

Add lines such as:

```ini
[Service]
Environment=BOTH_UPDATE_INTERVAL=43200
```

Do not edit `/usr/bin/asl3-update-nodelist` to change this value.

## Resetting Database State
To reset after a suspected database corruption:

```bash
rm -f /var/lib/asterisk/rpt_extnodes /var/lib/asterisk/asl3un-hash
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

