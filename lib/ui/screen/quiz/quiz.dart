import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/component/loading_view.dart';
import 'package:meta_bio/ui/screen/quiz/bloc/quiz_bloc.dart';
import 'package:meta_bio/ui/screen/quiz/component/question.dart';

class QuizScreen extends StatefulWidget {
  final Exam exam;

  const QuizScreen({super.key, required this.exam});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _questionPageController = PageController();
  int _currentQuestionPage = 0;

  @override
  void dispose() {
    _questionPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) =>
          QuizBloc(GetIt.I.get(), widget.exam.id)..add(const Started()),
      child: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state.submitRequestState is RequestStateSuccess) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushReplacement(MaterialPageRoute(
                builder: (context) => const Text(
                    'Result Screen') //TODO Implement the result screen
                ));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Stack(
              children: [
                _buildBackground(),
                _buildTopContainer(context, screenHeight),
                state.questions.isNotEmpty
                    ? Column(
                        children: [
                          _buildQuestionsPageView(context, state),
                          _buildControlButtons(context, state.questions.length),
                        ],
                      )
                    : const SizedBox.shrink(),
                state.isLoading ? loadingView(context) : const SizedBox.shrink()
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
      title: Text(
        widget.exam.title,
        style: const TextStyle(
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

  Widget _buildTopContainer(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight * 0.4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildQuestionsPageView(BuildContext context, QuizState state) {
    return Expanded(
      child: PageView.builder(
        controller: _questionPageController,
        itemCount: state.questions.length,
        onPageChanged: (index) {
          setState(() {
            _currentQuestionPage = index;
          });
        },
        itemBuilder: (context, index) {
          final question = state.questions[index];
          final selectedVariantIds =
              state.selectedVariantIds[question.id] ?? {};

          return QuestionItem(
              question: question,
              selectedVariantIds: selectedVariantIds,
              currentQuestionIndex: index,
              time: state.time,
              questionCount: state.questions.length);
        },
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context, int questionCount) {
    final isLastQuestion = _currentQuestionPage == questionCount - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 115,
      decoration: const BoxDecoration(color: Color(0xFF0D0D0D)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPreviousButton(context),
          const SizedBox(width: 16),
          if (isLastQuestion)
            _buildFinishButton(context)
          else
            _buildNextButton(context),
        ],
      ),
    );
  }

  Widget _buildPreviousButton(BuildContext context) {
    return _ControllerButtonContainer(
      onPressed: () {
        _questionPageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
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
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return _ControllerButtonContainer(
      onPressed: () {
        _questionPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
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
    );
  }

  Widget _buildFinishButton(BuildContext context) {
    return _ControllerButtonContainer(
      onPressed: () {
        BlocProvider.of<QuizBloc>(context).add(const Submit());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Finish',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.flag,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ControllerButtonContainer extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _ControllerButtonContainer({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
}
