import 'package:flutter/material.dart';

class ExamResultReviewHeader extends StatefulWidget {
  final List<bool> questionResults;
  final Function(int selectedIndex) onQuestionSelected;

  const ExamResultReviewHeader(
      {super.key,
      required this.questionResults,
      required this.onQuestionSelected});

  @override
  State<ExamResultReviewHeader> createState() => _ExamResultReviewHeaderState();
}

class _ExamResultReviewHeaderState extends State<ExamResultReviewHeader> {
  int selectedQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.questionResults.length,
            (index) => _buildQuestionResult(index),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionResult(int index) {
    final isCorrect = widget.questionResults[index];

    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          color: selectedQuestionIndex == index
              ? (isCorrect
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.error)
              : Colors.transparent,
          width: selectedQuestionIndex == index ? 2 : 0,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            fixedSize: const Size(50, 50),
            padding: EdgeInsets.zero,
            backgroundColor:
                isCorrect ? const Color(0xFF0E2F26) : const Color(0xFF2E1C1C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )),
        onPressed: () {
          setState(() {
            selectedQuestionIndex = index;
          });

          widget.onQuestionSelected(index);
        },
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: isCorrect
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
