import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:register_offline/core/dependency_injection/injection_container.dart'
    as di;
import 'package:register_offline/core/utils/app_theme.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/presentation/bloc/member_bloc.dart';

class AddMemberPage extends StatelessWidget {
  final String token;
  final MemberLocal? existingMember;

  const AddMemberPage({super.key, required this.token, this.existingMember});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.serviceLocator<MemberBloc>(),
      child: _AddMemberView(token: token, existingMember: existingMember),
    );
  }
}

class _AddMemberView extends StatefulWidget {
  final String token;
  final MemberLocal? existingMember;

  const _AddMemberView({required this.token, this.existingMember});

  @override
  State<_AddMemberView> createState() => _AddMemberViewState();
}

class _AddMemberViewState extends State<_AddMemberView> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _addressController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _kotaKabupatenController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kodePosController = TextEditingController();
  final _alamatDomisiliController = TextEditingController();
  final _provinsiDomisiliController = TextEditingController();
  final _kotaKabupatenDomisiliController = TextEditingController();
  final _kecamatanDomisiliController = TextEditingController();
  final _kelurahanDomisiliController = TextEditingController();
  final _kodePosDomisiliController = TextEditingController();

  DateTime? _birthDate;
  String? _gender;
  String? _status;
  String? _occupation;
  bool _sameAsKtp = true;

  File? _ktpFile;
  File? _ktpFileSecondary;

  final ImagePicker _picker = ImagePicker();

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _statusOptions = [
    'Menikah',
    'Belum Menikah',
    'Cerai Hidup',
    'Cerai Mati',
  ];
  final List<String> _occupationOptions = [
    'Pegawai Negeri',
    'Pegawai Swasta',
    'Wiraswasta',
    'Petani',
    'Pelajar/Mahasiswa',
    'Lainnya',
  ];

  bool get _isEditing => widget.existingMember != null;

  @override
  void initState() {
    super.initState();
    _populateExistingData();
  }

  void _populateExistingData() {
    final m = widget.existingMember;
    if (m == null) return;
    _phoneController.text = m.phone;
    _nikController.text = m.nik;
    _nameController.text = m.name ?? '';
    _birthPlaceController.text = m.birthPlace ?? '';
    _addressController.text = m.address ?? '';
    _provinsiController.text = m.provinsi ?? '';
    _kotaKabupatenController.text = m.kotaKabupaten ?? '';
    _kecamatanController.text = m.kecamatan ?? '';
    _kelurahanController.text = m.kelurahan ?? '';
    _kodePosController.text = m.kodePos ?? '';
    _alamatDomisiliController.text = m.alamatDomisili ?? '';
    _provinsiDomisiliController.text = m.provinsiDomisili ?? '';
    _kotaKabupatenDomisiliController.text = m.kotaKabupatenDomisili ?? '';
    _kecamatanDomisiliController.text = m.kecamatanDomisili ?? '';
    _kelurahanDomisiliController.text = m.kelurahanDomisili ?? '';
    _kodePosDomisiliController.text = m.kodePosDomisili ?? '';
    _gender = m.gender;
    _status = m.status;
    _occupation = m.occupation;
    _sameAsKtp = m.sameAsKtp;
    if (m.birthDate != null) {
      try {
        _birthDate = DateTime.parse(m.birthDate!);
      } catch (_) {}
    }
    if (m.ktpFilePath != null) _ktpFile = File(m.ktpFilePath!);
    if (m.ktpFileSecondaryPath != null) {
      _ktpFileSecondary = File(m.ktpFileSecondaryPath!);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nikController.dispose();
    _nameController.dispose();
    _birthPlaceController.dispose();
    _addressController.dispose();
    _provinsiController.dispose();
    _kotaKabupatenController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _kodePosController.dispose();
    _alamatDomisiliController.dispose();
    _provinsiDomisiliController.dispose();
    _kotaKabupatenDomisiliController.dispose();
    _kecamatanDomisiliController.dispose();
    _kelurahanDomisiliController.dispose();
    _kodePosDomisiliController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isPrimary) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: AppTheme.primaryBlue,
              ),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppTheme.primaryBlue,
              ),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (image != null) {
      setState(() {
        if (isPrimary) {
          _ktpFile = File(image.path);
        } else {
          _ktpFileSecondary = File(image.path);
        }
      });
    }
  }

  MemberLocal _buildMember() {
    return MemberLocal(
      id: widget.existingMember?.id,
      phone: _phoneController.text.trim(),
      nik: _nikController.text.trim(),
      name: _nameController.text.trim(),
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _birthDate != null
          ? DateFormat('yyyy-MM-dd').format(_birthDate!)
          : null,
      gender: _gender,
      status: _status,
      occupation: _occupation,
      address: _addressController.text.trim(),
      provinsi: _provinsiController.text.trim(),
      kotaKabupaten: _kotaKabupatenController.text.trim(),
      kecamatan: _kecamatanController.text.trim(),
      kelurahan: _kelurahanController.text.trim(),
      kodePos: _kodePosController.text.trim(),
      sameAsKtp: _sameAsKtp,
      alamatDomisili: _sameAsKtp
          ? _addressController.text.trim()
          : _alamatDomisiliController.text.trim(),
      provinsiDomisili: _sameAsKtp
          ? _provinsiController.text.trim()
          : _provinsiDomisiliController.text.trim(),
      kotaKabupatenDomisili: _sameAsKtp
          ? _kotaKabupatenController.text.trim()
          : _kotaKabupatenDomisiliController.text.trim(),
      kecamatanDomisili: _sameAsKtp
          ? _kecamatanController.text.trim()
          : _kecamatanDomisiliController.text.trim(),
      kelurahanDomisili: _sameAsKtp
          ? _kelurahanController.text.trim()
          : _kelurahanDomisiliController.text.trim(),
      kodePosDomisili: _sameAsKtp
          ? _kodePosController.text.trim()
          : _kodePosDomisiliController.text.trim(),
      ktpFilePath: _ktpFile?.path,
      ktpFileSecondaryPath: _ktpFileSecondary?.path,
      syncStatus: SyncStatus.draft,
      createdAt: widget.existingMember?.createdAt ?? DateTime.now(),
    );
  }

  void _saveDraft() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final member = _buildMember();
    if (_isEditing) {
      context.read<MemberBloc>().add(MemberEventUpdateDraft(member: member));
    } else {
      context.read<MemberBloc>().add(MemberEventSaveDraft(member: member));
    }
  }

  void _uploadNow() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_ktpFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto KTP utama wajib diisi!'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    final member = _buildMember();
    context.read<MemberBloc>().add(
      MemberEventUpload(member: member, token: widget.token),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(_isEditing ? 'Edit Data' : 'Tambah Data'),
        elevation: 0,
      ),
      body: BlocConsumer<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state is MemberStateSaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Draft berhasil disimpan!'),
                  ],
                ),
                backgroundColor: AppTheme.successGreen,
              ),
            );
            context.pop();
          } else if (state is MemberStateUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.successGreen,
              ),
            );
            context.pop();
          } else if (state is MemberStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is MemberStateLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Data Utama'),
                  const SizedBox(height: 4),
                  _buildInfoBanner(
                    'Nomor Handphone, NIK, Foto KTP, dan Foto Diri wajib diisi sebelum disimpan / di-upload',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Nomor Handphone', required: true),
                  _buildTextField(
                    controller: _phoneController,
                    hint: 'Masukkan nomor handphone',
                    inputType: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Nomor handphone wajib diisi'
                        : null,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('NIK', required: true),
                  _buildTextField(
                    controller: _nikController,
                    hint: '16 digit no KTP',
                    inputType: TextInputType.number,
                    maxLength: 16,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'NIK wajib diisi';
                      if (v.length != 16) return 'NIK harus 16 digit';
                      return null;
                    },
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Foto KTP', required: true),
                  Text(
                    'Ambil 2 foto KTP untuk hasil yang lebih baik.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildPhotoBox(
                        file: _ktpFile,
                        label: 'KTP Utama',
                        onTap: () => _pickImage(true),
                        onRemove: () => setState(() => _ktpFile = null),
                      ),
                      const SizedBox(width: 12),
                      _buildPhotoBox(
                        file: _ktpFileSecondary,
                        label: 'KTP Pendukung',
                        onTap: () => _pickImage(false),
                        onRemove: () =>
                            setState(() => _ktpFileSecondary = null),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Informasi Lainnya'),
                  const SizedBox(height: 16),

                  _buildLabel('Nama Lengkap'),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Masukkan nama sesuai KTP',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Tempat Lahir'),
                  _buildTextField(
                    controller: _birthPlaceController,
                    hint: 'Masukkan tempat lahir sesuai KTP',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Tanggal Lahir'),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _birthDate ?? DateTime(1990),
                        firstDate: DateTime(1940),
                        lastDate: DateTime.now(),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppTheme.primaryBlue,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setState(() => _birthDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _birthDate != null
                                ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                                : 'DD/MM/YY',
                            style: TextStyle(
                              color: _birthDate != null
                                  ? AppTheme.textPrimary
                                  : const Color(0xFFB0B8C4),
                              fontSize: 14,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: AppTheme.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Jenis Kelamin'),
                  _buildDropdown(
                    value: _gender,
                    hint: 'Pilih jenis kelamin',
                    items: _genderOptions,
                    onChanged: (v) => setState(() => _gender = v),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Status'),
                  _buildDropdown(
                    value: _status,
                    hint: 'Pilih status sesuai KTP',
                    items: _statusOptions,
                    onChanged: (v) => setState(() => _status = v),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Pekerjaan'),
                  _buildDropdown(
                    value: _occupation,
                    hint: 'Pilih pekerjaan sesuai KTP',
                    items: _occupationOptions,
                    onChanged: (v) => setState(() => _occupation = v),
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Informasi Alamat KTP'),
                  const SizedBox(height: 16),

                  _buildLabel('Alamat Lengkap'),
                  _buildTextField(
                    controller: _addressController,
                    hint: 'Masukkan alamat sesuai KTP',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Provinsi'),
                  _buildTextField(
                    controller: _provinsiController,
                    hint: 'Pilih Provinsi',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Kota/Kabupaten'),
                  _buildTextField(
                    controller: _kotaKabupatenController,
                    hint: 'Pilih Kota/Kabupaten',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Kecamatan'),
                  _buildTextField(
                    controller: _kecamatanController,
                    hint: 'Pilih Kecamatan',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Kelurahan'),
                  _buildTextField(
                    controller: _kelurahanController,
                    hint: 'Pilih Kelurahan',
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Kode Pos'),
                  _buildTextField(
                    controller: _kodePosController,
                    hint: 'Masukkan Kode Pos',
                    inputType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Alamat Domisili'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Checkbox(
                        value: _sameAsKtp,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (v) {
                          setState(() => _sameAsKtp = v ?? true);
                        },
                      ),
                      const Text(
                        'Alamat domisili sama dengan alamat pada KTP',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  if (!_sameAsKtp) ...[
                    const SizedBox(height: 16),
                    _buildLabel('Alamat Lengkap'),
                    _buildTextField(
                      controller: _alamatDomisiliController,
                      hint: 'Masukkan alamat domisili',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Provinsi'),
                    _buildTextField(
                      controller: _provinsiDomisiliController,
                      hint: 'Pilih Provinsi',
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Kota/Kabupaten'),
                    _buildTextField(
                      controller: _kotaKabupatenDomisiliController,
                      hint: 'Pilih Kota/Kabupaten',
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Kecamatan'),
                    _buildTextField(
                      controller: _kecamatanDomisiliController,
                      hint: 'Pilih Kecamatan',
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Kelurahan'),
                    _buildTextField(
                      controller: _kelurahanDomisiliController,
                      hint: 'Pilih Kelurahan',
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Kode Pos'),
                    _buildTextField(
                      controller: _kodePosDomisiliController,
                      hint: 'Masukkan Kode Pos',
                      inputType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],

                  const SizedBox(height: 32),

                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryBlue,
                      ),
                    )
                  else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _uploadNow,
                        child: const Text('Upload'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _saveDraft,
                        child: const Text('Simpan sebagai Draft'),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlue,
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppTheme.primaryBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
          children: required
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppTheme.errorRed),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? inputType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      inputFormatters: formatters,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(hintText: hint, counterText: ''),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: const TextStyle(color: Color(0xFFB0B8C4), fontSize: 14),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildPhotoBox({
    required File? file,
    required String label,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: file != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppTheme.errorRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: AppTheme.primaryBlue,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
