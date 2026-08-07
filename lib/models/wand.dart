class Wand {
  final String wood;
  final String core;
  final num length;

  Wand({
    required this.wood,
    required this.core,
    required this.length,
  });

  factory Wand.fromJson(Map<String, dynamic> json) {
    return Wand(
      wood: json['wood'] as String,
      core: json['core'] as String,
      length: (json['length'] as num?) ?? 0,
    );
  }
}
