part of example;

class Demo extends State {

  Config config;

  Demo(Config this.config);


  create() {

    var text = "Dark\nOverlord\nof Data";
    TextStyle style = new TextStyle(font: "65px Arial", fill: "#ff0044", align: "right");

    var t = game.add.text(game.world.centerX - 300, 0, text, style);

  }
}
