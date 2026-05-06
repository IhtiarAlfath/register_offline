// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

part of 'member_local_model.dart';

class MemberLocalModelAdapter extends TypeAdapter<MemberLocalModel> {
  @override
  final int typeId = 1;

  @override
  MemberLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberLocalModel(
      id: fields[0] as int?,
      phone: fields[1] as String,
      nik: fields[2] as String,
      name: fields[3] as String?,
      birthPlace: fields[4] as String?,
      birthDate: fields[5] as String?,
      gender: fields[6] as String?,
      status: fields[7] as String?,
      occupation: fields[8] as String?,
      address: fields[9] as String?,
      provinsi: fields[10] as String?,
      kotaKabupaten: fields[11] as String?,
      kecamatan: fields[12] as String?,
      kelurahan: fields[13] as String?,
      kodePos: fields[14] as String?,
      sameAsKtp: fields[15] as bool,
      alamatDomisili: fields[16] as String?,
      provinsiDomisili: fields[17] as String?,
      kotaKabupatenDomisili: fields[18] as String?,
      kecamatanDomisili: fields[19] as String?,
      kelurahanDomisili: fields[20] as String?,
      kodePosDomisili: fields[21] as String?,
      ktpFilePath: fields[22] as String?,
      ktpFileSecondaryPath: fields[23] as String?,
      syncStatusIndex: fields[24] as int,
      createdAt: fields[25] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MemberLocalModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.nik)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.birthPlace)
      ..writeByte(5)
      ..write(obj.birthDate)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.occupation)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.provinsi)
      ..writeByte(11)
      ..write(obj.kotaKabupaten)
      ..writeByte(12)
      ..write(obj.kecamatan)
      ..writeByte(13)
      ..write(obj.kelurahan)
      ..writeByte(14)
      ..write(obj.kodePos)
      ..writeByte(15)
      ..write(obj.sameAsKtp)
      ..writeByte(16)
      ..write(obj.alamatDomisili)
      ..writeByte(17)
      ..write(obj.provinsiDomisili)
      ..writeByte(18)
      ..write(obj.kotaKabupatenDomisili)
      ..writeByte(19)
      ..write(obj.kecamatanDomisili)
      ..writeByte(20)
      ..write(obj.kelurahanDomisili)
      ..writeByte(21)
      ..write(obj.kodePosDomisili)
      ..writeByte(22)
      ..write(obj.ktpFilePath)
      ..writeByte(23)
      ..write(obj.ktpFileSecondaryPath)
      ..writeByte(24)
      ..write(obj.syncStatusIndex)
      ..writeByte(25)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
