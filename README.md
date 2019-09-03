# supercolliderStandaloneBBBheadless
Standalone for BeagleBone Black with Debian.

This is the audio synthesis program [SuperCollider](https://github.com/supercollider/supercollider) version 3.10.3 (branch 3.10, commit 39ed52c, 30aug2019) + [sc3-plugins](https://github.com/supercollider/sc3-plugins) (branch 3.10, commit 6d69ae9, 5mar2019) compiled for BeagleBone Black.

The standalone was built using [this guide](https://supercollider.github.io/development/building-beagleboneblack) and tested to run under [Debian 9.5 2018-10-07 4GB SD IoT](http://beagleboard.org/latest-images), [bone-debian-9.9-console-armhf-2019-08-03-1gb.img](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Debian_Stretch_Console_Snapshot), [bone-debian-10.0-console-armhf-2019-08-25-1gb.img](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Debian_Buster_Console_Snapshot). It also works on the **PocketBeagle** and likely the other beagleboard models.

This standalone is self-contained and all files are in one directory.

installation
--

_(this assumes you have done all the usual initialisation... burned the disk image, booted, logged in via ssh or monitor, changed password, expanded the filesystem)_

in a BBB terminal window type...

* `sudo apt-get update`
* `sudo apt-get install git libfftw3-bin libavahi-client3`
* `git clone git://github.com/redFrik/supercolliderStandaloneBBBheadless --depth 1`

and then build and install jack2...

* `sudo apt-get install build-essential python libasound2-dev libsamplerate0-dev libsndfile1-dev libreadline-dev`
* `git clone git://github.com/jackaudio/jack2.git --depth 1`
* `cd jack2`
* `./waf configure --alsa`
* `./waf build`
* `sudo ./waf install`
* `sudo ldconfig`
* `cd ..`
* `rm -rf jack2`
* `sudo nano /etc/security/limits.conf` #and add the following two lines at the end
  * `@audio - memlock 256000`
  * `@audio - rtprio 75`
* `nano ~/.jackdrc` #and add the following (use -dhw:1 for usb soundcard)
  * `/usr/local/bin/jackd -P75 -dalsa -dhw:1 -r44100 -p1024 -n3`
* `sudo reboot`

startup
--

Start by opening a terminal window (or log in via ssh) and type...

* `cd supercolliderStandaloneBBBheadless`
* `./sclang -a -l ~/supercolliderStandaloneBBBheadless/sclang.yaml`

NOTE: one can also specify a .scd file to load when starting sclang like this: `./sclang -a -l ~/supercolliderStandaloneBBBheadless/sclang.yaml mycode.scd`

autostart
--

* `crontab -e` #and add the following line to the end
  * `@reboot cd /home/debian/supercolliderStandaloneBBBheadless && ./autostart.sh`
* `sudo reboot` #and supercollider should automatically start after a while and play some beating sine tones.

Then edit the autostart script to load whichever file. By default it will load `mycode.scd`.

cpu speed
--

to avoid audio dropouts on the BBB make sure you are running at 1GHz. The following command will change the governor from *ondemand* to *performance*.

* `sudo apt-get install cpufrequtils`
* `sudo cpufreq-set -g performance`

also power the BBB from barrel jack or gpio pins - the mini usb port will cap the cpu at 300MHz.
