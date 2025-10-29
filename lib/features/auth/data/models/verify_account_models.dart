class VerifyAccountRequest {
  final String phone;
  final String code;
  const VerifyAccountRequest({required this.phone, required this.code});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
      };
}

class VerifyAccountResponse {
  final String token;
  const VerifyAccountResponse({required this.token});

  factory VerifyAccountResponse.fromJson(Map<String, dynamic> json) =>
      VerifyAccountResponse(token: (json['token'] ?? '') as String);
}
