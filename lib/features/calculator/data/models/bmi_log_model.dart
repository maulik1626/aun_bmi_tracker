class BmiLogModel {
  final int? id;
  final int profileId;
  final double weightKg;
  final double heightCm;
  final double bmi;
  final String category;
  final DateTime recordedAt;

  const BmiLogModel({
    this.id,
    required this.profileId,
    required this.weightKg,
    required this.heightCm,
    required this.bmi,
    required this.category,
    required this.recordedAt,
  });

  factory BmiLogModel.fromMap(Map<String, dynamic> map) {
    return BmiLogModel(
      id: map['id'] as int?,
      profileId: map['profile_id'] as int,
      weightKg: (map['weight_kg'] as num).toDouble(),
      heightCm: (map['height_cm'] as num).toDouble(),
      bmi: (map['bmi'] as num).toDouble(),
      category: map['category'] as String,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'profile_id': profileId,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'bmi': bmi,
      'category': category,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'BmiLogModel(id: $id, profileId: $profileId, bmi: ${bmi.toStringAsFixed(1)}, '
        'category: $category, recordedAt: $recordedAt)';
  }
}
