sudo /run/current-system/activate
sudo systemctl daemon-reload
sudo systemctl restart home-manager-$USER.service
systemctl --user restart plasma-plasmashell.service