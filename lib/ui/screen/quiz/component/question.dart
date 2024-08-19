import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_bio/domain/question.dart';
import 'package:meta_bio/ui/screen/quiz/bloc/quiz_bloc.dart';
import 'package:meta_bio/ui/screen/quiz/component/variant_list.dart';

class QuestionItem extends StatelessWidget {
  final int questionCount;
  final int currentQuestionIndex;
  final Question question;
  final Set<int> selectedVariantIds;
  final String time;

  const QuestionItem(
      {super.key,
      required this.question,
      required this.selectedVariantIds,
      required this.currentQuestionIndex,
      required this.time,
      required this.questionCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
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
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFFC5CCDB),
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
        ),
      ),
    );
  }

  Widget _buildQuestionItem(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        question.text,
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
    return VariantList(
      variants: question.variants,
      selectedVariantIds: selectedVariantIds,
      questionType: question.type,
      onVariantSelected: (variantId) => _onVariantSelected(context, variantId),
    );
  }

  void _onVariantSelected(BuildContext context, int variantId) {
    context.read<QuizBloc>().add(VariantSelected(
        questionId: question.id,
        variantId: variantId,
        questionType: question.type));
  }
}
