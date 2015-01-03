Rails-box
=========

A vagrant setup to bring up a quick rails server

Note:
- running `$ rails server` to instatiate WEBrick works locally with curl on the vagrant box, but does not correctly forward to the host machine.
- include `gem puma` to get a working dev server.  Use `puma -p 3000` to start the web server.
