import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta_bio/domain/exam_result.dart';
import 'package:meta_bio/ui/screen/exam_result/bloc/exam_result_bloc.dart';
import 'package:meta_bio/ui/screen/exam_result/component/result_tab.dart';

class ExamResultScreen extends StatelessWidget {
  final ExamResult examResult;

  const ExamResultScreen({super.key, required this.examResult});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamResultBloc(examResult, context),
      child: Scaffold(
        body: BlocConsumer<ExamResultBloc, ExamResultState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(
              children: [
                _buildBackground(),
                Column(
                  children: [
                    _buildHeader(context, state),
                    const SizedBox(height: 20),
                    ResultTab(examResult: examResult),
                    const Spacer(),
                    _buildBackButton(context),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      color: const Color(0xFF171717),
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildHeader(BuildContext context, ExamResultState state) {
    return Container(
      height: 144,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Results',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Check your result',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0x330D0D0D),
              borderRadius: BorderRadius.all(Radius.circular(60)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/star.svg',
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFF7D426),
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  state.profile?.score.toString() ?? '0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 115,
      decoration: const BoxDecoration(color: Color(0xFF0D0D0D)),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Go back',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
