
           ___ ___ __  __    _               
      ____/ (_) (_) /_/ /_  (_)_  ______ ___ 
     / __  / / / / __/ __ \/ / / / / __ `__ \
    / /_/ / / / / /_/ / / / / /_/ / / / / / /
    \__,_/_/_/_/\__/_/ /_/_/\__,_/_/ /_/ /_/ 
                                             
                                                                      
==&lt; dilithium &gt;==

'Cause Every Phaser Needs A Warp Core'

* manage assets with yaml configuration file

```dart
void main() {

  Dilithium
  .using("packages/appname")
  .then((config) => new Game(config));

}

```

* scaffold generator
```bash
$ li2 create path Project --template default

```
