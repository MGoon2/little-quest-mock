import 'package:flutter/material.dart';

import 'package:little_quest/app/theme/lq_colors.dart';
import 'package:little_quest/features/signup/presentation/widgets/signup_dimensions.dart';

class BirthDateSelector extends StatelessWidget {
  final int? year;
  final int? month;
  final int? day;
  final ValueChanged<int?> onYearChanged;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onDayChanged;

  const BirthDateSelector({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.onYearChanged,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(80, (index) => currentYear - index);
    final months = List<int>.generate(12, (index) => index + 1);
    final days = List<int>.generate(31, (index) => index + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '생년월일',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: LqColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _BirthDateDropdown(
                fieldKey: const ValueKey('signup_birth_year'),
                value: year,
                hint: '년',
                items: years,
                onChanged: onYearChanged,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _BirthDateDropdown(
                fieldKey: const ValueKey('signup_birth_month'),
                value: month,
                hint: '월',
                items: months,
                onChanged: onMonthChanged,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _BirthDateDropdown(
                fieldKey: const ValueKey('signup_birth_day'),
                value: day,
                hint: '일',
                items: days,
                onChanged: onDayChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BirthDateDropdown extends StatelessWidget {
  final Key fieldKey;
  final int? value;
  final String hint;
  final List<int> items;
  final ValueChanged<int?> onChanged;

  const _BirthDateDropdown({
    required this.fieldKey,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SignupDimensions.inputHeight,
      child: DropdownButtonFormField<int>(
        key: fieldKey,
        initialValue: value,
        icon: const Icon(Icons.keyboard_arrow_down, color: LqColors.textSubtle),
        decoration: InputDecoration(
          labelText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.76),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SignupDimensions.fieldRadius),
            borderSide: const BorderSide(color: LqColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SignupDimensions.fieldRadius),
            borderSide: const BorderSide(color: LqColors.primaryGreen),
          ),
        ),
        hint: Text(
          hint,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 15,
            color: LqColors.textSubtle,
          ),
        ),
        items: [
          for (final item in items)
            DropdownMenuItem<int>(
              value: item,
              child: Text(
                '$item',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  color: LqColors.textDark,
                ),
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
