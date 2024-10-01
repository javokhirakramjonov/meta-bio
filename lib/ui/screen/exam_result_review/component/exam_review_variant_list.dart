import 'package:flutter/material.dart';
import 'package:meta_bio/domain/question_type.dart';
import 'package:meta_bio/domain/variant.dart';

class ExamResultReviewVariantList extends StatelessWidget {
  final List<Variant> variants;
  final Set<int> selectedVariantIds;
  final QuestionType questionType;
  final Set<int> correctVariantIds;

  const ExamResultReviewVariantList(
      {super.key,
      required this.variants,
      required this.selectedVariantIds,
      required this.questionType,
      required this.correctVariantIds});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: variants
            .map((variant) => _buildVariant(context, variant))
            .toList());
  }

  Widget _buildVariant(BuildContext context, Variant variant) {
    final isVariantCorrect = correctVariantIds.contains(variant.id);
    final shouldCheck =
        selectedVariantIds.contains(variant.id) || isVariantCorrect;

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
          leading: questionType == QuestionType.singleChoice
              ? Radio<int>(
                  onChanged: (value) {},
                  value: variant.id,
                  groupValue: shouldCheck ? variant.id : null,
                  activeColor: isVariantCorrect
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                )
              : Checkbox(
                  onChanged: null,
                  value: shouldCheck
                      ? selectedVariantIds.contains(variant.id)
                      : false,
                  checkColor: isVariantCorrect
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
        ));
  }
}
