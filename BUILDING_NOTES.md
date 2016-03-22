#notes

Instructions for building these binaries and set up a similar standalone repository...

First build and install SuperCollider 3.7 on a BBB (or other Linux box) following the instructions in the Wheezy section [here](http://supercollider.github.io/development/building-beagleboneblack). One can also use an existing sc install assuming all the files are in their default directories.

NOTE: also build jackd2 from git source and do not install it with apt-get (see README.md).

* `mkdir supercolliderStandaloneBBBheadless && cd supercolliderStandaloneBBBheadless`
* `cp /usr/local/bin/sclang /usr/local/bin/scsynth .`
* `cp -r /usr/local/lib/SuperCollider/plugins .` #copies all plugins
* `mkdir -p share/system`
* `cp -r /usr/local/share/SuperCollider/* share/system` #copies help, classes, examples etc
* `mkdir -p share/system/Extensions/SystemOverwrites`
* `curl -o share/system/Extensions/SystemOverwrites/extLinuxPlatform.sc https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/system/Extensions/SystemOverwrites/extLinuxPlatform.sc`
* `mkdir share/users`
* `curl -o share/users/archive.sctxar https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/share/user/archive.sctxar`
* `curl -o sclang.yaml https://raw.githubusercontent.com/redFrik/supercolliderStandaloneBBBheadless/master/sclang.yaml`

Now this directory should contain what is needed to run sc standalone (if started as in the README.md). Copy it to another machine with the same system and try.

publish
--

My own additional notes for this git repository...

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
