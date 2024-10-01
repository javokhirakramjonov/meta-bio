import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/exam_result_review_item.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/screen/exam_result_review/bloc/exam_result_review_bloc.dart';
import 'package:meta_bio/ui/screen/exam_result_review/component/exam_result_review_header.dart';
import 'package:meta_bio/ui/screen/exam_result_review/component/exam_result_review_item_view.dart';
import 'package:meta_bio/ui/screen/exam_result_review/component/exam_result_review_shimmer.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class ExamResultReviewScreen extends StatefulWidget {
  final int examId;

  const ExamResultReviewScreen({super.key, required this.examId});

  @override
  State<ExamResultReviewScreen> createState() => _ExamResultReviewScreenState();
}

class _ExamResultReviewScreenState extends State<ExamResultReviewScreen> {
  final _scrollController = ScrollController();
  late ListObserverController _observerController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamResultReviewBloc(GetIt.I.get(), context)
        ..add(ExamResultReviewEvent.started(widget.examId)),
      child: Scaffold(
        backgroundColor: const Color(0xFF171717),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xFF0D0D0D)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: const Text(
            'Exam Result Review',
            style: TextStyle(
              color: Color(0xFF0D0D0D),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ExamResultReviewBloc, ExamResultReviewState>(
          builder: (context, state) {
            final examResultReviewItemsState = state.examResultReviewItemsState;

            return Column(
              children: [
                if (examResultReviewItemsState
                    is RequestStateSuccess<List<ExamResultReviewItem>>) ...[
                  ExamResultReviewHeader(
                    questionResults: examResultReviewItemsState.data
                        .map((examResultReviewItem) {
                      return examResultReviewItem.correctVariantIds.length ==
                              examResultReviewItem.selectedVariantIds.length &&
                          examResultReviewItem.correctVariantIds.containsAll(
                              examResultReviewItem.selectedVariantIds);
                    }).toList(),
                    onQuestionSelected: (index) async {
                      _observerController.animateTo(
                          index: index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                  ),
                ],
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<ExamResultReviewBloc>()
                          .add(ExamResultReviewEvent.started(widget.examId));
                    },
                    child: examResultReviewItemsState
                            is RequestStateSuccess<List<ExamResultReviewItem>>
                        ? _buildExamResultReviewItems(
                            examResultReviewItemsState)
                        : examResultReviewItemsState is RequestStateLoading
                            ? const ExamResultReviewShimmer()
                            : const Center(
                                child: Text('No exam result review available')),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExamResultReviewItems(
      RequestStateSuccess<List<ExamResultReviewItem>> examsRequestState) {
    _observerController = ListObserverController(controller: _scrollController);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: ListViewObserver(
        controller: _observerController,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          itemCount: examsRequestState.data.length,
          itemBuilder: (context, index) {
            return ExamResultReviewItemView(
                currentQuestionIndex: index,
                questionCount: examsRequestState.data.length,
                examResultReviewItem: examsRequestState.data[index]);
          },
        ),
      ),
    );
  }
}
