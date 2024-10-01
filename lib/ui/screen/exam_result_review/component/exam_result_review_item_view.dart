import 'package:flutter/material.dart';
import 'package:meta_bio/domain/exam_result_review_item.dart';
import 'package:meta_bio/ui/screen/exam_result_review/component/exam_review_variant_list.dart';

class ExamResultReviewItemView extends StatelessWidget {
  final int currentQuestionIndex;
  final int questionCount;
  final ExamResultReviewItem examResultReviewItem;

  const ExamResultReviewItemView(
      {super.key,
      required this.examResultReviewItem,
      required this.currentQuestionIndex,
      required this.questionCount});

  @override
  Widget build(BuildContext context) {
    final isCorrect = areSelectedVariantsCorrect();

    return Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} out of $questionCount',
                    style: const TextStyle(
                      color: Color(0xFF9CA2A7),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color(0xFF0E2F26)
                          : const Color(0xFF2E1C1C),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Text(
                      isCorrect ? 'Correct' : 'Incorrect',
                      style: TextStyle(
                        color: isCorrect
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildQuestionItem(context),
            ],
          ),
        ));
  }

  Widget _buildQuestionItem(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        examResultReviewItem.question.text,
        style: const TextStyle(
          color: Color(0xFFC5CCDB),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 20),
      _buildVariants(context)
    ]);
  }

  Widget _buildVariants(BuildContext context) {
    return ExamResultReviewVariantList(
      variants: examResultReviewItem.question.variants,
      selectedVariantIds: examResultReviewItem.selectedVariantIds,
      questionType: examResultReviewItem.question.type,
      correctVariantIds: examResultReviewItem.correctVariantIds,
    );
  }

  bool areSelectedVariantsCorrect() {
    return examResultReviewItem.selectedVariantIds.length ==
            examResultReviewItem.correctVariantIds.length &&
        examResultReviewItem.correctVariantIds
            .containsAll(examResultReviewItem.selectedVariantIds);
  }
}
