import 'package:flutter/material.dart';
import 'package:meta_bio/domain/question_type.dart';
import 'package:meta_bio/domain/variant.dart';

class VariantList extends StatelessWidget {
  final List<Variant> variants;
  final Set<int> selectedVariantIds;
  final QuestionType questionType;
  final void Function(int) onVariantSelected;

  const VariantList(
      {super.key,
      required this.variants,
      required this.selectedVariantIds,
      required this.questionType,
      required this.onVariantSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: variants
            .map((variant) => _buildVariant(context, variant))
            .toList());
  }

  Widget _buildVariant(BuildContext context, Variant variant) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          title: Text(
            variant.text,
            style: const TextStyle(
              color: Color(0xFFC5CCDB),
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () => onVariantSelected(variant.id),
          leading: questionType == QuestionType.singleChoice
              ? Radio<int>(
                  value: variant.id,
                  groupValue: selectedVariantIds.firstOrNull,
                  onChanged: (_) => onVariantSelected(variant.id),
                  activeColor: Theme.of(context).colorScheme.primary,
                )
              : Checkbox(
                  value: selectedVariantIds.contains(variant.id),
                  onChanged: (_) => onVariantSelected(variant.id),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
        ));
  }
}
