import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = <({String question, String answer})>[
      (
        question: 'كيف أجد الحافلات القريبة؟',
        answer:
            'فعّل إذن الموقع ثم استخدم الخريطة لرؤية الحافلات والرحلات المتاحة بالقرب منك.',
      ),
      (
        question: 'كيف يتم احتساب الأجرة؟',
        answer:
            'تظهر الأجرة المتوقعة في بطاقة الرحلة قبل تأكيد الحجز، بناءً على المسافة والوقت.',
      ),
      (
        question: 'كيف أتواصل مع الدعم؟',
        answer:
            'يمكنك التواصل مع فريق الدعم من خلال مركز المساعدة أو البريد الإلكتروني المسجل في حسابك.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('المساعدة والدعم')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'كيف يمكننا مساعدتك؟',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            'إجابات سريعة عن استخدام Navio والرحلات.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                for (final item in questions)
                  ExpansionTile(
                    title: Text(item.question, textAlign: TextAlign.right),
                    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    children: [Text(item.answer, textAlign: TextAlign.right)],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم التواصل معك قريباً')),
              );
            },
            icon: const Icon(Icons.support_agent),
            label: const Text('تواصل مع الدعم'),
          ),
        ],
      ),
    );
  }
}
