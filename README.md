# supercolliderStandaloneBBBheadless
Standalone SuperCollider for BeagleBone Black Debian Jessie.

This is the audio synthesis program [SuperCollider](http://github.com/supercollider/supercollider) (3.8.0, commit 0947edd, 5nov2016) + [sc3-plugins](https://github.com/supercollider/sc3-plugins) (master, commit f1200cd, 8nov2016) compiled for beaglebone black.

It was built using [this guide](http://supercollider.github.io/development/building-beagleboneblack) on a **BeagleBone Black** under [bone-debian-8.6-iot-armhf-2016-11-06-4gb.img](http://beagleboard.org/latest-images) (Jessie).

The standalone structure is loosely based on [Miguel Negrão's template](https://github.com/miguel-negrao/scStandalone). This standalone is self-contained and all files are in one directory.

NOTE: this standalone does not include the full SuperCollider IDE. For the IDE use [this](https://github.com/redFrik/supercolliderStandaloneBBB) repository.

installation
--

open the terminal on the BBB and type...

* `sudo apt-get update`
* `sudo apt-get install libcwiid1 libfftw3-bin libavahi-client3`
* `git clone git://github.com/redFrik/supercolliderStandaloneBBBheadless --depth 1`

and then build and install jack2...

* `sudo apt-get install libasound2-dev libsamplerate0-dev libsndfile1-dev libreadline-dev`
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
* `sudo nano /etc/ssh/sshd_config` #at the bottom change to UsePAM yes
* `sudo reboot`

startup
--

Start by opening a terminal window (or log in via ssh) and type...

* `jackd -P75 -dalsa -dhw:1 -p1024 -n3 -s -r44100 &` #edit -dhw to match your audio output. 0 is usually hdmi, and 1 the usb soundcard
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
