enum UserRole {
  applicant('Applicant'),
  lgAdmin('LG Admin'),
  superAdmin('Super Admin'),
  immigrationOfficer('Immigration Officer');

  final String label;

  const UserRole(this.label);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.label == value,
      orElse: () => UserRole.applicant,
    );
  }
}
