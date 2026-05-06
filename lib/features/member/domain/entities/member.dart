import 'package:equatable/equatable.dart';

enum SyncStatus { draft, synced }

class MemberLocal extends Equatable {
  final int? id;
  final String phone;
  final String nik;
  final String? name;
  final String? birthPlace;
  final String? birthDate;
  final String? gender;
  final String? status;
  final String? occupation;
  final String? address;
  final String? provinsi;
  final String? kotaKabupaten;
  final String? kecamatan;
  final String? kelurahan;
  final String? kodePos;
  final bool sameAsKtp;
  final String? alamatDomisili;
  final String? provinsiDomisili;
  final String? kotaKabupatenDomisili;
  final String? kecamatanDomisili;
  final String? kelurahanDomisili;
  final String? kodePosDomisili;
  final String? ktpFilePath;
  final String? ktpFileSecondaryPath;
  final SyncStatus syncStatus;
  final DateTime? createdAt;

  const MemberLocal({
    this.id,
    required this.phone,
    required this.nik,
    this.name,
    this.birthPlace,
    this.birthDate,
    this.gender,
    this.status,
    this.occupation,
    this.address,
    this.provinsi,
    this.kotaKabupaten,
    this.kecamatan,
    this.kelurahan,
    this.kodePos,
    this.sameAsKtp = true,
    this.alamatDomisili,
    this.provinsiDomisili,
    this.kotaKabupatenDomisili,
    this.kecamatanDomisili,
    this.kelurahanDomisili,
    this.kodePosDomisili,
    this.ktpFilePath,
    this.ktpFileSecondaryPath,
    this.syncStatus = SyncStatus.draft,
    this.createdAt,
  });

  MemberLocal copyWith({
    int? id,
    String? phone,
    String? nik,
    String? name,
    String? birthPlace,
    String? birthDate,
    String? gender,
    String? status,
    String? occupation,
    String? address,
    String? provinsi,
    String? kotaKabupaten,
    String? kecamatan,
    String? kelurahan,
    String? kodePos,
    bool? sameAsKtp,
    String? alamatDomisili,
    String? provinsiDomisili,
    String? kotaKabupatenDomisili,
    String? kecamatanDomisili,
    String? kelurahanDomisili,
    String? kodePosDomisili,
    String? ktpFilePath,
    String? ktpFileSecondaryPath,
    SyncStatus? syncStatus,
    DateTime? createdAt,
  }) {
    return MemberLocal(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      nik: nik ?? this.nik,
      name: name ?? this.name,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      occupation: occupation ?? this.occupation,
      address: address ?? this.address,
      provinsi: provinsi ?? this.provinsi,
      kotaKabupaten: kotaKabupaten ?? this.kotaKabupaten,
      kecamatan: kecamatan ?? this.kecamatan,
      kelurahan: kelurahan ?? this.kelurahan,
      kodePos: kodePos ?? this.kodePos,
      sameAsKtp: sameAsKtp ?? this.sameAsKtp,
      alamatDomisili: alamatDomisili ?? this.alamatDomisili,
      provinsiDomisili: provinsiDomisili ?? this.provinsiDomisili,
      kotaKabupatenDomisili:
          kotaKabupatenDomisili ?? this.kotaKabupatenDomisili,
      kecamatanDomisili: kecamatanDomisili ?? this.kecamatanDomisili,
      kelurahanDomisili: kelurahanDomisili ?? this.kelurahanDomisili,
      kodePosDomisili: kodePosDomisili ?? this.kodePosDomisili,
      ktpFilePath: ktpFilePath ?? this.ktpFilePath,
      ktpFileSecondaryPath: ktpFileSecondaryPath ?? this.ktpFileSecondaryPath,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, phone, nik, name, birthPlace, birthDate, gender, status,
        occupation, address, provinsi, kotaKabupaten, kecamatan, kelurahan,
        kodePos, sameAsKtp, alamatDomisili, provinsiDomisili,
        kotaKabupatenDomisili, kecamatanDomisili, kelurahanDomisili,
        kodePosDomisili, ktpFilePath, ktpFileSecondaryPath, syncStatus,
      ];
}

class MemberRemote extends Equatable {
  final int? id;
  final String name;
  final String nik;
  final String phone;
  final String? ktpUrl;
  final String? ktpUrlSecondary;
  final String? birthPlace;
  final String? birthDate;
  final String? status;
  final String? occupation;

  const MemberRemote({
    this.id,
    required this.name,
    required this.nik,
    required this.phone,
    this.ktpUrl,
    this.ktpUrlSecondary,
    this.birthPlace,
    this.birthDate,
    this.status,
    this.occupation,
  });

  @override
  List<Object?> get props =>
      [id, name, nik, phone, ktpUrl, ktpUrlSecondary, birthPlace, birthDate];
}
