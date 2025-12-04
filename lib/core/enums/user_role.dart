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

  static UserRole fromApiRole(String apiRole) {
    switch (apiRole.toLowerCase()) {
      case 'applicant':
        return UserRole.applicant;
      case 'lg-admin':
      case 'lg_admin':
      case 'lg admin':
        return UserRole.lgAdmin;
      case 'super-admin':
      case 'super_admin':
      case 'super admin':
        return UserRole.superAdmin;
      case 'immigration-officer':
      case 'immigration_officer':
      case 'immigration officer':
        return UserRole.immigrationOfficer;
      default:
        return UserRole.applicant;
    }
  }

  String toApiRole() {
    switch (this) {
      case UserRole.applicant:
        return 'applicant';
      case UserRole.lgAdmin:
        return 'lg-admin';
      case UserRole.superAdmin:
        return 'super-admin';
      case UserRole.immigrationOfficer:
        return 'immigration-officer';
    }
  }
}
