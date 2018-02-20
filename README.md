# supercolliderStandaloneBBBheadless
Standalone SuperCollider for BeagleBone Black Debian Stretch.

This is the audio synthesis program [SuperCollider](http://github.com/supercollider/supercollider) (3.9.1, commit f15598c, 9feb2018) + [sc3-plugins](https://github.com/supercollider/sc3-plugins) (master, commit 9307b41, 2feb2018) compiled for beaglebone black.

It was built using [this guide](http://supercollider.github.io/development/building-beagleboneblack) on a **BeagleBone Black** under [bone-debian-9.3-console-armhf-2018-02-18-1gb.img](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Stretch_Snapshot_console) (Stretch). It also works on the **PocketBeagle** and likely the other beagleboard models.

The standalone structure is loosely based on [Miguel Negrão's template](https://github.com/miguel-negrao/scStandalone). This standalone is self-contained and all files are in one directory.

installation
--

_(this assumes you have done all the usual initialisation... burned the disk image, booted, logged in via ssh or monitor, changed password)_

in a BBB terminal window type...

* `sudo apt-get update`
* `sudo apt-get install git libx11-dev libcwiid1 libfftw3-bin libavahi-client3`
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
* `./sclang -a -l sclang.yaml`

NOTE: one can also specify a .scd file to load when starting sclang like this: `./sclang -a -l sclang.yaml mycode.scd`

autostart
--

* `crontab -e` #and add the following line to the end
* `@reboot cd /home/debian/supercolliderStandaloneBBBheadless && ./autostart.sh`
* `sudo reboot` #and supercollider should automatically start after a while and play some beating sine tones.

Then edit the autostart script to load whichever file. By default it will load `mycode.scd`.

cpu speed
--

to avoid audio dropouts on the BBB make sure you are running at 1GHz. The following command will change the governor from *ondemand* to *performance*.

* `sudo cpufreq-set -g performance`

and to make the change permanent run...

* `echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils`

also power the BBB from barrel jack or gpio pins - the mini usb port will cap the cpu at 300MHz.
