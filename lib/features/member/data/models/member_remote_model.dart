import 'package:register_offline/features/member/domain/entities/member.dart';

class MemberRemoteModel extends MemberRemote {
  const MemberRemoteModel({
    super.id,
    required super.name,
    required super.nik,
    required super.phone,
    super.ktpUrl,
    super.ktpUrlSecondary,
    super.birthPlace,
    super.birthDate,
    super.status,
    super.occupation,
  });

  factory MemberRemoteModel.fromJson(Map<String, dynamic> json) {
    return MemberRemoteModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      nik: json['nik'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      ktpUrl: json['ktp_url'] as String?,
      ktpUrlSecondary: json['ktp_url_secondary'] as String?,
      birthPlace: json['birth_place'] as String?,
      birthDate: json['birth_date'] as String?,
      status: json['status'] as String?,
      occupation: json['occupation'] as String?,
    );
  }
}
