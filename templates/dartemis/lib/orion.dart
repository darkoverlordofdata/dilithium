/**
 * Orion and Artemis
 */
library orion;

import 'package:dartemis/dartemis.dart';
import 'package:play_phaser/phaser.dart' as Phaser;
import 'package:play_phaser/arcade.dart' as Arcade;

part 'src/Context.dart';
part 'src/EntityFactory.dart';
part 'src/Game.dart';
part 'src/components/Animation.dart';
part 'src/components/Bounce.dart';
part 'src/components/Count.dart';
part 'src/components/Gravity.dart';
part 'src/components/Immovable.dart';
part 'src/components/Position.dart';
part 'src/components/Scale.dart';
part 'src/components/Text.dart';
part 'src/components/Sprite.dart';
part 'src/components/Velocity.dart';
part 'src/systems/ArcadePhysicsSystem.dart';
part 'src/systems/BackgroundRenderSystem.dart';
part 'src/systems/PlatformRenderSystem.dart';
part 'src/systems/PlayerControlSystem.dart';
part 'src/systems/ScoreRenderSystem.dart';
part 'src/systems/StarsRenderSystem.dart';

