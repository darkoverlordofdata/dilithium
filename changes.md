## changes
### v0.2.0 - Nov 9, 2014
* Added coffee version
### v0.2.1 - Nov 9, 2014
* fix syncronous request should be async
### v0.2.2 - Nov 19, 2014
* Copy new config load from coffee to dart
### v0.2.3 - Nov 20, 2014
* templating now uses liquid.coffee
* fix preload progress display
* check for CocoonJS
### v0.2.4 - Nov 30, 2014
* fix config.width, config.height
### v0.2.5 - Dec 06, 2014
* add config.id
### v0.3.1 - Dec 24, 2014
* breaking changes:
* remove Li2Button & Li2State - prefer composition, such as with Artemis
* remove Li2* prefix - import using 'as'
### v0.3.5 - Jan 18, 2015
* adding config.orientation to take advantage of screen.orientation.lock()
* add scaleMode to config
* add config.transparent