import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/ui/screen/quiz/quiz.dart';

class ExamItem extends StatelessWidget {
  final Exam exam;

  const ExamItem({
    super.key,
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => QuizScreen(exam: exam),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(),
              buildDivider(),
              buildRow(context),
              if (exam.result != null) ...[
                buildDivider(),
                buildResultRow(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      exam.title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget buildDivider() {
    return const Divider(height: 32, color: Color(0xFF1C1C1C));
  }

  Widget buildRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRichText(
                  'Question(s): ', exam.questionsCount.toString(), context),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRichText(
                  'Submission(s): ', exam.submissionsCount.toString(), context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildResultRow(BuildContext context) {
    final examItemResult = exam.result;

    if (examItemResult == null) {
      return const Text('No result found');
    }

    return Row(
      children: [
        const Text(
          'Your result:',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFC5CCDB)),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/star.svg',
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFF7D426),
                    BlendMode.srcIn,
                  ),
                  width: 16,
                ),
                const SizedBox(width: 4),
                Text('+${examItemResult.score}',
                    style: const TextStyle(color: Color(0xFFC5CCDB))),
                const SizedBox(width: 16),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.timer, color: Color(0xFFF7D426), size: 18),
                const SizedBox(width: 4),
                Text(
                    examItemResult.duration
                        .substring(0, examItemResult.duration.indexOf('.')),
                    style: const TextStyle(color: Color(0xFFC5CCDB))),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/tick.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  width: 18,
                ),
                const SizedBox(width: 4),
                Text(examItemResult.correctCount.toString(),
                    style: const TextStyle(color: Color(0xFFC5CCDB))),
                const SizedBox(width: 16),
                SvgPicture.asset(
                  'assets/icons/close.svg',
                  colorFilter: const ColorFilter.mode(
                      Color(0xFFD83033), BlendMode.srcIn),
                  width: 18,
                ),
                const SizedBox(width: 4),
                Text(examItemResult.inCorrectCount.toString(),
                    style: const TextStyle(color: Color(0xFFC5CCDB))),
              ],
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget buildRichText(String label, String value, BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
                color: Color(0xFFB6B8BD), fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
