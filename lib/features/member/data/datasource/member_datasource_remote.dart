import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/app_constants.dart';
import 'package:register_offline/core/utils/logger.dart';
import 'package:register_offline/features/member/data/models/member_remote_model.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';

abstract class MemberDatasourceRemote {
  Future<GeneralSuccess> uploadMember(MemberLocal member, String token);
  Future<List<MemberRemoteModel>> getMembers(String token);
}

class MemberDatasourceRemoteImpl implements MemberDatasourceRemote {
  final http.Client client;

  MemberDatasourceRemoteImpl({required this.client});

  Future<File> _compressImage(String filePath) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_ktp.jpg';

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        format: CompressFormat.jpeg,
        quality: 80,
        minWidth: 1024,
        minHeight: 768,
      );

      if (result != null) {
        final compressedFile = File(result.path);
        if (await compressedFile.exists()) {
          logInfo(
            'Compressed: ${result.path} (${(await compressedFile.length() / 1024).toStringAsFixed(1)} KB)',
          );
          return compressedFile;
        }
      }

      logError('Compress gagal, pakai file asli: $filePath');
      return File(filePath);
    } catch (e) {
      logError('Compress error: $e — pakai file asli');
      return File(filePath);
    }
  }

  Future<http.MultipartFile> _buildMultipartFile(
    String fieldName,
    File file,
  ) async {
    final filePath = file.path;
    final ext = path.extension(filePath).toLowerCase();

    MediaType mediaType;
    if (ext == '.jpg' || ext == '.jpeg') {
      mediaType = MediaType('image', 'jpeg');
    } else if (ext == '.png') {
      mediaType = MediaType('image', 'png');
    } else if (ext == '.pdf') {
      mediaType = MediaType('application', 'pdf');
    } else {
      mediaType = MediaType('image', 'jpeg');
    }

    final fileName = path.basename(filePath);

    logInfo('Uploading $fieldName: $fileName (${mediaType.mimeType})');

    return http.MultipartFile.fromBytes(
      fieldName,
      await file.readAsBytes(),
      filename: fileName,
      contentType: mediaType,
    );
  }

  @override
  Future<GeneralSuccess> uploadMember(MemberLocal member, String token) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/member');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = member.name ?? '';
      request.fields['nik'] = member.nik;
      request.fields['phone'] = member.phone;
      request.fields['birth_place'] = member.birthPlace ?? '';
      request.fields['birth_date'] = member.birthDate ?? '';
      request.fields['status'] = member.status ?? '';
      request.fields['occupation'] = member.occupation ?? '';
      request.fields['address'] = member.address ?? '';
      request.fields['provinsi'] = member.provinsi ?? '';
      request.fields['kota_kabupaten'] = member.kotaKabupaten ?? '';
      request.fields['kecamatan'] = member.kecamatan ?? '';
      request.fields['kelurahan'] = member.kelurahan ?? '';
      request.fields['kode_pos'] = member.kodePos ?? '';

      request.fields['alamat_domisili'] = member.sameAsKtp
          ? (member.address ?? '')
          : (member.alamatDomisili ?? '');
      request.fields['provinsi_domisili'] = member.sameAsKtp
          ? (member.provinsi ?? '')
          : (member.provinsiDomisili ?? '');
      request.fields['kota_kabupaten_domisili'] = member.sameAsKtp
          ? (member.kotaKabupaten ?? '')
          : (member.kotaKabupatenDomisili ?? '');
      request.fields['kecamatan_domisili'] = member.sameAsKtp
          ? (member.kecamatan ?? '')
          : (member.kecamatanDomisili ?? '');
      request.fields['kelurahan_domisili'] = member.sameAsKtp
          ? (member.kelurahan ?? '')
          : (member.kelurahanDomisili ?? '');
      request.fields['kode_pos_domisili'] = member.sameAsKtp
          ? (member.kodePos ?? '')
          : (member.kodePosDomisili ?? '');

      if (member.ktpFilePath != null) {
        final originalFile = File(member.ktpFilePath!);
        if (await originalFile.exists()) {
          final compressed = await _compressImage(member.ktpFilePath!);
          final multipartFile = await _buildMultipartFile(
            'ktp_file',
            compressed,
          );
          request.files.add(multipartFile);
        } else {
          logError('KTP file tidak ditemukan: ${member.ktpFilePath}');
        }
      }

      if (member.ktpFileSecondaryPath != null) {
        final originalFile = File(member.ktpFileSecondaryPath!);
        if (await originalFile.exists()) {
          final compressed = await _compressImage(member.ktpFileSecondaryPath!);
          final multipartFile = await _buildMultipartFile(
            'ktp_file_secondary',
            compressed,
          );
          request.files.add(multipartFile);
        } else {
          logError(
            'KTP secondary file tidak ditemukan: ${member.ktpFileSecondaryPath}',
          );
        }
      }

      logInfo(
        'Sending multipart request: ${request.fields.length} fields, ${request.files.length} files',
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      logInfo('Upload response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const GeneralSuccess(message: 'Member berhasil diupload');
      } else {
        Map<String, dynamic> json = {};
        try {
          json = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        final errMsg =
            json['message'] ??
            json['error'] ??
            'Upload gagal (${response.statusCode})';
        throw ServerException(message: errMsg);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Upload gagal: ${e.toString()}');
    }
  }

  @override
  Future<List<MemberRemoteModel>> getMembers(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}/member'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json
            .map((e) => MemberRemoteModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw const ServerException(message: 'Gagal mengambil data member');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Get members gagal: ${e.toString()}');
    }
  }
}
