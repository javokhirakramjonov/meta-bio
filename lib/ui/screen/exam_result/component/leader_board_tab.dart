import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta_bio/domain/exam_leader.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/screen/exam_result/bloc/exam_result_bloc.dart';

class LeaderBoardTab extends StatefulWidget {
  final RequestState<List<ExamLeader>> allStudentsExamResultRequestState;

  const LeaderBoardTab(
      {super.key, required this.allStudentsExamResultRequestState});

  @override
  State<LeaderBoardTab> createState() => _LeaderBoardTabState();
}

class _LeaderBoardTabState extends State<LeaderBoardTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.allStudentsExamResultRequestState is RequestStateLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.allStudentsExamResultRequestState
        is! RequestStateSuccess<List<ExamLeader>>) {
      return const SizedBox.shrink();
    }

    final allStudentsExamResult = (widget.allStudentsExamResultRequestState
            as RequestStateSuccess<List<ExamLeader>>)
        .data;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            context
                .read<ExamResultBloc>()
                .add(const LoadAllStudentsExamResults());
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: allStudentsExamResult.length,
            itemBuilder: (context, index) {
              final examItemResult = allStudentsExamResult[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Text(examItemResult.rank.toString(),
                        style: const TextStyle(color: Color(0xFFC5CCDB))),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar.png',
                          width: 48,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${examItemResult.user.firstName} ${examItemResult.user.lastName}',
                            style: const TextStyle(
                                color: Color(0xFFC6D0D9),
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/tick.svg',
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.primary,
                                    BlendMode.srcIn),
                                width: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(examItemResult.correctCount.toString(),
                                  style: const TextStyle(
                                      color: Color(0xFFC5CCDB))),
                              const SizedBox(width: 16),
                              SvgPicture.asset(
                                'assets/icons/close.svg',
                                colorFilter: const ColorFilter.mode(
                                    Color(0xFFD83033), BlendMode.srcIn),
                                width: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(examItemResult.inCorrectCount.toString(),
                                  style: const TextStyle(
                                      color: Color(0xFFC5CCDB))),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF171717),
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                      ),
                      child: Text(
                        examItemResult.duration
                            .substring(0, examItemResult.duration.indexOf('.')),
                        style: const TextStyle(
                          color: Color(0xFFC5CCDB),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
