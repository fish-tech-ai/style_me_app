enum CountdownOptionEnum {
  threeSeconds("assets/timer_3.svg", 3),
  fiveSeconds("assets/timer_5.svg", 5),
  tenSeconds("assets/timer_10.svg", 10);

  final String svgAssetPath;
  final int value;

  const CountdownOptionEnum(this.svgAssetPath, this.value);
}
