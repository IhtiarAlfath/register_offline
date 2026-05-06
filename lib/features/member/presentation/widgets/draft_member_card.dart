import 'dart:io';
import 'package:flutter/material.dart';
import 'package:register_offline/core/utils/app_theme.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';

class DraftMemberCard extends StatelessWidget {
  final MemberLocal member;
  final int index;
  final VoidCallback onUpload;
  final VoidCallback onEdit;

  const DraftMemberCard({
    super.key,
    required this.member,
    required this.index,
    required this.onUpload,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildKtpThumb(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _maskNik(member.nik),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _maskPhone(member.phone),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.draftOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Draft',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.draftOrange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(36),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.upload_outlined, size: 16),
                    label: const Text('Upload'),
                    onPressed: onUpload,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(36),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKtpThumb() {
    if (member.ktpFilePath != null) {
      final file = File(member.ktpFilePath!);
      return Image.file(
        file,
        width: 52,
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _ktpPlaceholder(),
      );
    }
    return _ktpPlaceholder();
  }

  Widget _ktpPlaceholder() {
    return Container(
      width: 52,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.lightBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.credit_card_outlined,
        size: 20,
        color: AppTheme.primaryBlue,
      ),
    );
  }

  String _maskNik(String nik) {
    if (nik.length <= 6) return nik;
    return '${nik.substring(0, 3)}${'*' * (nik.length - 6)}${nik.substring(nik.length - 3)}';
  }

  String _maskPhone(String phone) {
    if (phone.length <= 6) return phone;
    return '${phone.substring(0, 3)}${'*' * (phone.length - 6)}${phone.substring(phone.length - 3)}';
  }
}
