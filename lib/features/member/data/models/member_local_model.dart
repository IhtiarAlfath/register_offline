import 'package:hive/hive.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';

part 'member_local_model.g.dart';

@HiveType(typeId: 1)
class MemberLocalModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String nik;

  @HiveField(3)
  String? name;

  @HiveField(4)
  String? birthPlace;

  @HiveField(5)
  String? birthDate;

  @HiveField(6)
  String? gender;

  @HiveField(7)
  String? status;

  @HiveField(8)
  String? occupation;

  @HiveField(9)
  String? address;

  @HiveField(10)
  String? provinsi;

  @HiveField(11)
  String? kotaKabupaten;

  @HiveField(12)
  String? kecamatan;

  @HiveField(13)
  String? kelurahan;

  @HiveField(14)
  String? kodePos;

  @HiveField(15)
  bool sameAsKtp;

  @HiveField(16)
  String? alamatDomisili;

  @HiveField(17)
  String? provinsiDomisili;

  @HiveField(18)
  String? kotaKabupatenDomisili;

  @HiveField(19)
  String? kecamatanDomisili;

  @HiveField(20)
  String? kelurahanDomisili;

  @HiveField(21)
  String? kodePosDomisili;

  @HiveField(22)
  String? ktpFilePath;

  @HiveField(23)
  String? ktpFileSecondaryPath;

  @HiveField(24)
  int syncStatusIndex;

  @HiveField(25)
  DateTime? createdAt;

  MemberLocalModel({
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
    this.syncStatusIndex = 0,
    this.createdAt,
  });

  factory MemberLocalModel.fromEntity(MemberLocal entity) {
    return MemberLocalModel(
      id: entity.id,
      phone: entity.phone,
      nik: entity.nik,
      name: entity.name,
      birthPlace: entity.birthPlace,
      birthDate: entity.birthDate,
      gender: entity.gender,
      status: entity.status,
      occupation: entity.occupation,
      address: entity.address,
      provinsi: entity.provinsi,
      kotaKabupaten: entity.kotaKabupaten,
      kecamatan: entity.kecamatan,
      kelurahan: entity.kelurahan,
      kodePos: entity.kodePos,
      sameAsKtp: entity.sameAsKtp,
      alamatDomisili: entity.alamatDomisili,
      provinsiDomisili: entity.provinsiDomisili,
      kotaKabupatenDomisili: entity.kotaKabupatenDomisili,
      kecamatanDomisili: entity.kecamatanDomisili,
      kelurahanDomisili: entity.kelurahanDomisili,
      kodePosDomisili: entity.kodePosDomisili,
      ktpFilePath: entity.ktpFilePath,
      ktpFileSecondaryPath: entity.ktpFileSecondaryPath,
      syncStatusIndex: entity.syncStatus.index,
      createdAt: entity.createdAt,
    );
  }

  MemberLocal toEntity() {
    return MemberLocal(
      id: id,
      phone: phone,
      nik: nik,
      name: name,
      birthPlace: birthPlace,
      birthDate: birthDate,
      gender: gender,
      status: status,
      occupation: occupation,
      address: address,
      provinsi: provinsi,
      kotaKabupaten: kotaKabupaten,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
      kodePos: kodePos,
      sameAsKtp: sameAsKtp,
      alamatDomisili: alamatDomisili,
      provinsiDomisili: provinsiDomisili,
      kotaKabupatenDomisili: kotaKabupatenDomisili,
      kecamatanDomisili: kecamatanDomisili,
      kelurahanDomisili: kelurahanDomisili,
      kodePosDomisili: kodePosDomisili,
      ktpFilePath: ktpFilePath,
      ktpFileSecondaryPath: ktpFileSecondaryPath,
      syncStatus: SyncStatus.values[syncStatusIndex],
      createdAt: createdAt,
    );
  }
}
