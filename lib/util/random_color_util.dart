import 'dart:math';
import 'dart:ui';

final Random _random = Random();

Color getRandomColor() {

  int red = _random.nextInt(256);
  int green = _random.nextInt(256);
  int blue = _random.nextInt(256);

  return Color.fromRGBO(red, green, blue, 1.0);
}
