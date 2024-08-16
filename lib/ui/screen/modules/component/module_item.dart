import 'package:flutter/material.dart';

class ModuleItem extends StatelessWidget {
  final String title;
  final int examCount;

  const ModuleItem({super.key, required this.title, required this.examCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF0D0D0D),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/images/dna.png'),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFC5CCDB),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: 'Exams: ',
                style: TextStyle(
                  color: Color(0xFFB6B8BD),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: '$examCount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
