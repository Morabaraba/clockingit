ClockingIT v0.99.4: TimeTracking 2.0
====================================
#### MIT/X11 license

A simple fork of ClockingIT to install on Ubuntu 12.04 LTS.

```sh
curl https://codeload.github.com/ludoza/clockingit/zip/master -o cit.zip
unzip cit.zip
cd clockingit-master
chmod +x install.ubuntu.12.04.sh
sudo ./install.ubuntu.12.04.sh
```

It will ask you to set a mysql root password. Remember it because you will need it later in the process.

### import *.clockingit.com mysql dump

You can restore your *.clockingit.com mysql dump file, but you will need to remove the last column from `users` and `companies` in your data set.
