class ProfileModel {
  final int? id;
  final String name;
  final DateTime? dateOfBirth;
  final String gender;
  final double heightCm;
  final bool isActive;

  const ProfileModel({
    this.id,
    required this.name,
    this.dateOfBirth,
    required this.gender,
    required this.heightCm,
    this.isActive = true,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.parse(map['date_of_birth'] as String)
          : null,
      gender: map['gender'] as String? ?? '',
      heightCm: (map['height_cm'] as num?)?.toDouble() ?? 0.0,
      isActive: (map['is_active'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'height_cm': heightCm,
      'is_active': isActive ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, gender: $gender, '
        'heightCm: $heightCm, isActive: $isActive)';
  }
}
