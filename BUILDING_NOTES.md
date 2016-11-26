#notes

Instructions for building these binaries and set up a similar standalone repository...

First build and install SuperCollider on a BBB following the instructions [here](http://supercollider.github.io/development/building-beagleboneblack). One can also use an existing sc install assuming all the files are in their default directories.

NOTE: also build jackd2 from git source and do not install it with apt-get (see README.md).

* `mkdir supercolliderStandaloneBBBheadless && cd supercolliderStandaloneBBBheadless`
* `cp /usr/local/bin/sclang /usr/local/bin/scsynth .`
* `cp -r /usr/local/lib/SuperCollider/plugins .` #copies all plugins
* `mkdir -p share/system`
* `cp -r /usr/local/share/SuperCollider/* share/system` #copies help, classes, examples etc
* `mkdir -p share/system/Extensions/SystemOverwrites`
* `curl -o share/system/Extensions/SystemOverwrites/extLinuxPlatform.sc https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/system/Extensions/SystemOverwrites/extLinuxPlatform.sc`
* `mkdir share/user`
* `curl -o share/user/archive.sctxar https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/user/archive.sctxar`
* `curl -o sclang.yaml https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/sclang.yaml`
* `curl -o autostart.sh https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/autostart.sh`

Now this directory should contain what is needed to run sc standalone (if started as in the README.md). Copy it to another machine with the same system and try.

sc3-plugins
--

How to build and include sc3-plugins...

* `git clone --recursive https://github.com/supercollider/sc3-plugins.git --depth 1`
* `cd sc3-plugins`
* `mkdir build && cd build`
* `export CC=/usr/bin/gcc-4.8`
* `export CXX=/usr/bin/g++-4.8`
* `cmake -L -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS="-mfloat-abi=hard -mfpu=neon" -DCMAKE_CXX_FLAGS="-mfloat-abi=hard -mfpu=neon" -DSC_PATH=../../supercollider/ -DCMAKE_INSTALL_PREFIX=~/supercolliderStandaloneBBBheadless/share/system/Extensions/SC3plugins ..`
* `make`
* `sudo make install`
* `cd ~/supercolliderStandaloneBBBheadless/share/system/Extensions/`
* `sudo chown -R debian SC3plugins`
* `sudo chgrp -R debian SC3plugins`
* `mkdir SC3plugins/bin`
* `mv SC3plugins/lib/SuperCollider/plugins/*.so SC3plugins/bin/`
* `mv SC3plugins/share/SuperCollider/Extensions/SC3plugins/* SC3plugins/`
* `rm -rf SC3plugins/lib`
* `rm -rf SC3plugins/share`
* `rm -rf SC3plugins/local`

publish
--

My own additional notes for this git repository...

* note which git commit was used in README.md
* note which debian image was used in README.md
* copy the files over to laptop...
  * `cd supercolliderStandaloneBBBheadless`
  * `scp debian@beaglebone.local:supercolliderStandaloneBBBheadless/sc* .`
  * `rm -rf plugins`
  * `scp -r debian@beaglebone.local:supercolliderStandaloneBBBheadless/plugins .`
  * `rm -rf share`
  * `scp -r debian@beaglebone.local:supercolliderStandaloneBBBheadless/share .`
  * and possibly the yaml file as well if something changed
* git commit and sync
