# AllStarLink Nodelist Updater
This package maintains the file-based node lookup database
located at `/var/lib/asterisk/rpt_extnodes`. This replaces,
and conflicts with, the asl-update-node-list package for
ASL2. Use one or the other, but not both.

On installation of the package, the `asl3-update-nodelist.timer`
is enabled and will update the database one every 60 seconds
using the full/differential method.

## Resetting Database State
To reset after a suspected database corruption:

```
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

```
cp /lib/systemd/system/asl3-update-nodelist.timer /etc/systemd/system/asl3-update-nodelist.timer
vi /etc/systemd/system/asl3-update-nodelist.timer
systemctl daemon-reload
```
