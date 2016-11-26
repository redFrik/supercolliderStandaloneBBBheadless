# supercolliderStandaloneBBBheadless
Standalone SuperCollider for BeagleBone Black Debian Jessie.

This is the audio synthesis program [SuperCollider](http://github.com/supercollider/supercollider) (3.8.0, commit 0947edd, 5nov2016) compiled for beaglebone black.

It was built using [this guide](http://supercollider.github.io/development/building-beagleboneblack) on a **BeagleBone Black** under bone-debian-8.6-iot-armhf-2016-11-06-4gb.img (Jessie). It will also run under the older Wheezy.

The standalone structure is loosely based on [Miguel Negrão's template](https://github.com/miguel-negrao/scStandalone). This standalone is self-contained and all files are in one directory.

NOTE: this standalone does not include the full SuperCollider IDE. For the IDE use [this](https://github.com/redFrik/supercolliderStandaloneBBB) repository.

installation
--

open the terminal on the BBB and type...

* `sudo apt-get update`
* `sudo apt-get install libcwiid-dev libfftw3-dev libudev-dev`
* `sudo ln -s /usr/lib/arm-linux-gnueabihf/libudev.so /usr/lib/arm-linux-gnueabihf/libudev.so.0` #hack (jessie only)
* `git clone git://github.com/redFrik/supercolliderStandaloneBBBheadless --depth 1`

NOTE: also install a working jackd. See [jackd](#jackd) below.

NOTE: to avoid audio dropouts on the BBB make sure you are running at 1GHz. The following command will change the governor from *ondemand* to *performance*.

* `sudo cpufreq-set -g performance`

and to make the change permanent run...

* `echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils`

also power the BBB from barrel jack or gpio pins - the mini usb port will cap the cpu at 300MHz.

Also under **Jessie** sc will run smoother if you upgrade the kernel:

* `cd /opt/scripts/tools/`
* `git pull`
* `sudo ./update_kernel.sh --ti-channel --lts-4_1`

startup
--

Start by opening a terminal window (or log in via ssh) and type...

* `jackd -P75 -dalsa -dhw:1 -p1024 -n3 -s -r44100 &` #edit -dhw to match your audio output. 0 is usually hdmi, and 1 the usb soundcard
* `cd supercolliderStandaloneBBBheadless`
* `./sclang -a -l sclang.yaml`

NOTE: one can also specify a .scd file to load when starting sclang like this: `./sclang -a -l sclang.yaml mycode.scd`

autostart
--

* `sudo apt-get install xvfb`
* `crontab -e` #and add the following line to the end
  * `@reboot cd /home/debian/supercolliderStandaloneBBBheadless && xvfb-run ./autostart.sh`

Then edit the autostart script to load whichever file. By default it will load `mycode.scd`.

jackd
--

install a working version of jackd by compiling it from source (**Wheezy** and **Jessie**)...

* `sudo apt-get remove libjack-jackd2-0:armhf` #remove old libjack (wheezy only)
* `sudo apt-get install libasound2-dev libsamplerate0-dev libsndfile1-dev libreadline-dev`
* `git clone git://github.com/jackaudio/jack2 --depth 1`
* `cd jack2`
* `./waf configure --alsa`
* `./waf build`
* `sudo ./waf install`
* `sudo ldconfig`
* `cd ../..`
* `rm -rf jack2`

and then do the following to configure jackd...

* `sudo nano /etc/security/limits.conf` #and add the following two lines at the end
  * `@audio - memlock 256000`
  * `@audio - rtprio 75`
* `sudo nano /etc/ssh/sshd_config` #at the bottom change to UsePAM yes
* `sudo reboot` #and log in again to make the limits and sshd settings work

on **Jessie** you can alternatively install it with...

* `sudo apt-get install jackd` #allow realtime when asked

but you still need to configure jackd like above and also type the following each time before starting jack...

* `export DISPLAY=:0.0`

console & iot
--

for the console and iot images found [here](http://elinux.org/Beagleboard:BeagleBoneBlack_Debian) you will need to install a few more things...

* `sudo apt-get install git dbus-x11`

and then to start jack and supercollider do...

* `export DISPLAY=:0.0`
* ``export `dbus-launch | grep ADDRESS` ``
* ``export `dbus-launch | grep PID` ``
* `jackd -P75 -dalsa -dhw:1 -p1024 -n3 -s -r 44100 &`
