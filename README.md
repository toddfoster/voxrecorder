voxrecorder
===========

Rationale:
----------
Churches (and others) want to record events with a minimum of fiddling. A RaspberryPi is both cheap and powerful enough to get the job done.

A RaspberryPi, with audio input properly configured, can be left connected to
an audio feed from a PA system. Whenever there's audio output, it should be
captured to a file. When the system falls silent for longer than a specified
amount of time, the file should be closed out and a new one begun. The finished
files can be renamed with timestamps and made available to anybody on the LAN
in a directory shared by an http server.

Files can be cleaned up by hand (using software like [Audacity](https:audacity.sourceforge.net)) and distributed at will.

Support Work to be done on host device
---------------------------------------
- install [sox](http://sox.sourceforge.net)
- install voxrecorder: clone the [git repo]() for easy updates
- Configuration of audio input, especially:
	- Audio input levels on sound drivers to default recording device
	- silence threshold levels in script
- Accessible web server with public directory listing
- Might be nice to provide an explanation readme on the webserver
- Adapt config parameters in voxrecorder script
- Run voxrecorder on boot?
- Probably would be nice to reboot the Pi weekly (e.g., 3am Wed?) via cron.

TODO
-----
- ~~record non-silent programs~~
- ~~rename & move finished recordings~~
- ~~remove short recordings~~
- ~~verify amount of silence that signifies a break between files~~
	- seems to only delay around half the time specified - consistently
- remove oldest files when disk space is low

References
----------
- http://sox.sourceforge.net/sox.html
- http://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/

