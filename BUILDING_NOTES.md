Instructions for building these binaries and set up a similar standalone repository...

First build and install SuperCollider and sc3-plugins on a BBB following the [official build instructions](https://github.com/supercollider/supercollider/blob/develop/README_BEAGLEBONE_BLACK.md). One can also use an existing sc install assuming all the files are in their default directories.

(  
sc3-plugins are built and installed like this...

```
git clone --recursive https://github.com/supercollider/sc3-plugins.git
cd sc3-plugins
#git checkout 3.10  #optional select version
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE="Release" -DSUPERNOVA=OFF -DNATIVE=ON -DSC_PATH=../../supercollider/ ..
make
sudo make install
```
)

* `mkdir supercolliderStandaloneBBBheadless && cd supercolliderStandaloneBBBheadless`
* `cp /usr/local/bin/sclang /usr/local/bin/scsynth .` #this copies sclang and scsynth
* `cp -r /usr/local/lib/SuperCollider/plugins .` #copies all plugins including sc3-plugins
* `mkdir -p share/system`
* `cp -r /usr/local/share/SuperCollider/* share/system` #copies help, classes, examples etc
* `mkdir -p share/system/Extensions/SystemOverwrites`
* `curl -o share/system/Extensions/SystemOverwrites/extLinuxPlatform.sc https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/system/Extensions/SystemOverwrites/extLinuxPlatform.sc`
* `curl -o share/system/Extensions/SystemOverwrites/extPlatform.sc https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/system/Extensions/SystemOverwrites/extPlatform.sc`
* `mkdir share/user`
* `curl -o share/user/archive.sctxar https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/user/archive.sctxar`
* `curl -o share/user/startup.scd https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/user/startup.scd`
* `curl -o sclang.yaml https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/sclang.yaml`
* `curl -o autostart.sh https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/autostart.sh`
* `curl -o mycode.scd https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/mycode.scd`

Now this directory should contain what is needed to run sc standalone (if started as in the README.md). Copy it to another machine with the same system and try.

publish
--
My own additional notes for this git repository...

* note which git commit was used in README.md
* note which debian image was used in README.md
* copy the files over to laptop...
  * `cd supercolliderStandaloneBBBheadless`
  * `scp debian@beaglebone:supercolliderStandaloneBBBheadless/sc* .`
  * `rm -rf plugins`
  * `scp -r debian@beaglebone:supercolliderStandaloneBBBheadless/plugins .`
  * `rm -rf share`
  * `scp -r debian@beaglebone:supercolliderStandaloneBBBheadless/share .`
  * and possibly the yaml file as well if something changed
* make sure there is a binary release for previous version
* git commit and sync

