class Profile {
  final int? id;
  final String name;
  final DateTime? dateOfBirth;
  final String gender;
  final double heightCm;
  final bool isActive;

  const Profile({
    this.id,
    required this.name,
    this.dateOfBirth,
    required this.gender,
    required this.heightCm,
    this.isActive = true,
  });

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, gender: $gender, '
        'heightCm: $heightCm, isActive: $isActive)';
  }
}
