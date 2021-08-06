# supercolliderStandaloneBBBheadless
Standalone for BeagleBone Black with Debian.

This is the audio synthesis program [SuperCollider](https://github.com/supercollider/supercollider) version 3.12.0 (branch main, commit 028ff1b, 03aug2021) + [sc3-plugins](https://github.com/supercollider/sc3-plugins) (branch main, commit dca5c0b, 06aug2021) compiled for BeagleBone Black.

The standalone was built using [this guide](https://github.com/supercollider/supercollider/blob/develop/README_BEAGLEBONE_BLACK.md) and tested to run under [AM3358 Debian 10.3 2020-04-06 4GB SD IoT](https://beagleboard.org/latest-images), [bone-debian-10.4-console-armhf-2020-05-18-1gb.img](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Debian_Buster_Console_Snapshot). It also works on the **PocketBeagle** and likely the other beagleboard models.

This standalone is self-contained and all files are in one directory.

installation
--

_(this assumes you have done all the usual initialisation... burned the disk image, booted, logged in via ssh or monitor, changed password, expanded the filesystem (`sudo /opt/scripts/tools/grow_partition.sh`))_

In a BBB terminal window type...

* `sudo apt-get update`
* `sudo apt-get install git libfftw3-bin libavahi-client3`
* `git clone git://github.com/redFrik/supercolliderStandaloneBBBheadless --depth 1`

and then build and install jack2...

* `sudo apt-get install build-essential python3 libasound2-dev libsamplerate0-dev libsndfile1-dev libreadline-dev`
* `git clone git://github.com/jackaudio/jack2.git --depth 1`
* `cd jack2`
* `./waf configure --alsa`
* `./waf build`
* `sudo ./waf install`
* `sudo ldconfig`
* `cd ..`
* `rm -rf jack2`
* `sudo sh -c "echo @audio - memlock 256000 >> /etc/security/limits.conf"`
* `sudo sh -c "echo @audio - rtprio 75 >> /etc/security/limits.conf"`
* `echo /usr/local/bin/jackd -P75 -p16 -dalsa -dhw:1 -r44100 -p1024 -n3 > ~/.jackdrc` #-dhw:1 is for USB soundcard
* `sudo reboot`

startup
--

Start by opening a terminal window (or log in via SSH) and type...

* `cd supercolliderStandaloneBBBheadless`
* `./sclang -a -l ~/supercolliderStandaloneBBBheadless/sclang.yaml`

NOTE: one can also specify a .scd file to load when starting sclang like this: `./sclang -a -l ~/supercolliderStandaloneBBBheadless/sclang.yaml mycode.scd`

autostart
--

* `crontab -e` #and add the following line to the end
  * `@reboot cd /home/debian/supercolliderStandaloneBBBheadless && ./autostart.sh`
* `sudo reboot` #and supercollider should automatically start after a while and play some beating sine tones.

Then edit the autostart script to load whichever file. By default it will load `mycode.scd`.

CPU speed
--

To avoid audio dropouts on the BBB make sure you are running at 1GHz. The following command will change the governor from *ondemand* to *performance*.

* `sudo apt-get install cpufrequtils`
* `sudo cpufreq-set -g performance`

also power the BBB from the DC barrel jack or GPIO pins - the mini USB port will cap the CPU at 300MHz.
