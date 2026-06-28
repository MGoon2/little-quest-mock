import 'package:flutter/material.dart';

import '../../../../theme/lq_colors.dart';
import '../models/profile_edit_data.dart';

/// 프로필 수정 헤더 카드.
class ProfileEditHeaderCard extends StatelessWidget {
  final ProfileEditData data;

  const ProfileEditHeaderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '프로필',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: LqColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: LqColors.lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: LqColors.border, width: 2),
                      image: data.profileImageAssetPath != null
                          ? DecorationImage(
                              image: AssetImage(data.profileImageAssetPath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: data.profileImageAssetPath == null
                        ? const Icon(
                            Icons.park,
                            size: 48,
                            color: LqColors.primaryGreen,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: image picker / profile photo change
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: LqColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.nickname,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LqColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: LqColors.textSubtle,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LqColors.cardCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LqColors.border),
        boxShadow: [
          BoxShadow(
            color: LqColors.deepGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
