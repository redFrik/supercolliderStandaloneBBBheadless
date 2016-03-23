# supercolliderStandaloneBBBheadless
Standalone SuperCollider for BeagleBone Black Debian.

This is the audio synthesis program [SuperCollider](http://github.com/supercollider/supercollider) (3.7 branch) compiled for armv7l.

It was built using [this guide](http://supercollider.github.io/development/building-beagleboneblack) on a **BeagleBone Black** under bone-debian-7.9-lxde-4gb-armhf-2015-11-12-4gb.img (Wheezy). But it also run under the newer Jessie.

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

NOTE: to avoid audio dropouts on the BBB under **Jessie** make sure you are running at 1GHz. The following command will change the governor from *ondemand* to *performance*.

* `sudo cpufreq-set -g performance`

and to make the change permanent run...

* `echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils`

Under **Wheezy** this does not seem to make any noticeable difference and *ondemand* works good.

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

todo

jackd
==

install a working version of jackd by compiling it from source (wheesy and jessie)...

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

on **jessie** you can alternatively install it with...

* `sudo apt-get install jackd` #allow realtime when asked

but you still need to configure jackd like above and also type the following each time before starting jack...

* `export DISPLAY=:0.0`
