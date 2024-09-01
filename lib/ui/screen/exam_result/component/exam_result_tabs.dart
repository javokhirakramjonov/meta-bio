import 'package:flutter/material.dart';
import 'package:meta_bio/ui/screen/exam_result/bloc/exam_result_bloc.dart';
import 'package:meta_bio/ui/screen/exam_result/component/exam_result_tab.dart';
import 'package:meta_bio/ui/screen/exam_result/component/leader_board_tab.dart';
import 'package:meta_bio/ui/screen/exam_result/component/my_result_tab.dart';

class ExamResultTabs extends StatefulWidget {
  final ExamResultState examResultState;

  const ExamResultTabs({super.key, required this.examResultState});

  @override
  State<ExamResultTabs> createState() => _ExamResultTabsState();
}

class _ExamResultTabsState extends State<ExamResultTabs> {
  var currentTab = ExamResultTab.myResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(80),
          ),
          child: Row(
            children: ExamResultTab.values
                .map((tab) => Expanded(
                      child: _buildTab(context, tab.title, () {
                        setState(() {
                          currentTab = tab;
                        });
                      }, currentTab == tab),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        currentTab == ExamResultTab.myResult
            ? MyResultTab(examResult: widget.examResultState.examResult)
            : LeaderBoardTab(
                allStudentsExamResultRequestState:
                    widget.examResultState.allStudentsExamResultRequestState),
      ],
    );
  }

  Widget _buildTab(
      BuildContext context, String title, VoidCallback onTap, bool isSelected) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(30),
              )
            : null,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF0D0D0D)
                  : const Color(0xFF858991),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
