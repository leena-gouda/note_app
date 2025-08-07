import 'dart:ui';

class TextStyleRange {
  final int start;
  final int end;
  final FontWeight weight;

  TextStyleRange({
    required this.start,
    required this.end,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
    'weight': weight.index,
  };

  factory TextStyleRange.fromJson(Map<String, dynamic> json) => TextStyleRange(
    start: json['start'],
    end: json['end'],
    weight: FontWeight.values[json['weight']],
  );
}