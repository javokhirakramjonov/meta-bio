import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta_bio/domain/exam.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/screen/exams/bloc/exams_bloc.dart';
import 'package:meta_bio/ui/screen/exams/component/exam_item.dart';
import 'package:meta_bio/ui/screen/exams/component/exams_shimmer_list.dart';

class ExamsScreen extends StatefulWidget {
  final int moduleId;

  const ExamsScreen({super.key, required this.moduleId});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamsBloc(GetIt.I.get(), context)
        ..add(ExamsEvent.started(widget.moduleId)),
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
            'Exams',
            style: TextStyle(
              color: Color(0xFF0D0D0D),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ExamsBloc, ExamsState>(
          builder: (context, state) {
            final examsRequestState = state.examsRequestState;

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ExamsBloc>()
                    .add(ExamsEvent.started(widget.moduleId));
              },
              child: examsRequestState is RequestStateSuccess<List<Exam>>
                  ? _buildExamsList(examsRequestState)
                  : examsRequestState is RequestStateLoading
                      ? const ExamsShimmerList()
                      : const Center(child: Text('No exams available')),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExamsList(RequestStateSuccess<List<Exam>> examsRequestState) {
    return ListView.builder(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: examsRequestState.data.length,
      itemBuilder: (context, index) {
        return ExamItem(exam: examsRequestState.data[index]);
      },
    );
  }
}
