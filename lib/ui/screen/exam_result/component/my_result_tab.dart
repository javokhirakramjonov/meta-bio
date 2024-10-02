import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/ui/screen/exam_result_review/exam_result_review.dart';

class MyResultTab extends StatelessWidget {
  final ExamResult examResult;

  const MyResultTab({super.key, required this.examResult});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(48),
              decoration: const BoxDecoration(
                color: Color(0xFF0D0D0D),
                borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border.fromBorderSide(BorderSide(
                  color: Color(0xFF1C1C1C),
                )),
              ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/cup_dark.svg',
                    width: 80,
                  ),
                  const SizedBox(height: 34),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'You got',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFC5CCDB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' +${examResult.score} ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(
                          text: 'points',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFC5CCDB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D0D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          examResult.correctCount.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Correct Answers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D0D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          examResult.inCorrectCount.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Incorrect Answers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF1C1C1C),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    examResult.duration
                        .substring(0, examResult.duration.indexOf('.')),
                    style: const TextStyle(
                      color: Color(0xFFC5CCDB),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Spent time',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _openExamReviewButton(context),
          ],
        ),
      ),
      if (examResult.score > 0)
        IgnorePointer(
          child: Transform.scale(
            scale: 2,
            child: LottieBuilder.asset(
              height: 400,
              'assets/animations/congrats.json',
              repeat: false,
            ),
          ),
        ),
    ]);
  }

  Widget _openExamReviewButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 75,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ExamResultReviewScreen(resultId: examResult.id),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
        ),
        child: const Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            'See exam result review',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
