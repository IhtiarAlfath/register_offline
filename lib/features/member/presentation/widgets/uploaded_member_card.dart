import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:register_offline/core/utils/app_theme.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';

class UploadedMemberCard extends StatelessWidget {
  final MemberRemote member;
  final int index;

  const UploadedMemberCard({
    super.key,
    required this.member,
    required this.index,
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
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.uploadedGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.uploadedGreen,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.uploadedGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Di-upload',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.uploadedGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKtpThumb() {
    if (member.ktpUrl != null && member.ktpUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: member.ktpUrl!,
        width: 52,
        height: 36,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _ktpPlaceholder(),
        placeholder: (_, __) => _ktpPlaceholder(),
      );
    }
    return _ktpPlaceholder();
  }

  Widget _ktpPlaceholder() {
    return Container(
      width: 52,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.uploadedGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.credit_card_outlined,
        size: 20,
        color: AppTheme.uploadedGreen,
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
