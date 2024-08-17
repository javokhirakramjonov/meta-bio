import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/ui/screen/quiz/bloc/quiz_bloc.dart';

class QuizScreen extends StatelessWidget {
  final int examId;

  const QuizScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => QuizBloc(GetIt.I.get(), examId),
      child: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Stack(
              children: [
                _buildBackground(),
                Container(
                  height: screenHeight * 0.4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Card(
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
                                    const Text(
                                      'Question 3 out of 30',
                                      //TODO: Add question number
                                      style: TextStyle(
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
                                      child: const Text(
                                        '05:20', //TODO: Add timer
                                        style: TextStyle(
                                          color: Color(0xFFC5CCDB),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'What is the capital of France?',
                                  style: TextStyle(
                                    color: Color(0xFFC5CCDB),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildOptions(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildControlButtons(context),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        'Quiz',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
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

  Widget _buildControlButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 115,
      decoration: const BoxDecoration(color: Color(0xFF0D0D0D)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          controllerButtonContainer(
            context: context,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Back',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          controllerButtonContainer(
            context: context,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget controllerButtonContainer(
      {required BuildContext context,
      required VoidCallback onPressed,
      required Widget child}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
        ),
        child: Padding(padding: const EdgeInsets.all(18.0), child: child),
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Column(
      children: [
        _buildOption(context, 'Paris'),
        _buildOption(context, 'London'),
        _buildOption(context, 'Berlin'),
        _buildOption(context, 'Madrid'),
      ],
    );
  }

  Widget _buildOption(BuildContext context, String option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(
          option,
          style: const TextStyle(
            color: Color(0xFFC5CCDB),
            fontWeight: FontWeight.w700,
          ),
        ),
        onTap: () {},
        leading: Radio(
          value: option,
          groupValue: 'Berlin', //TODO: Add selected option
          onChanged: (value) {},
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
