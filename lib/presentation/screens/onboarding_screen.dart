import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'تتبع الحافلات في الوقت الحقيقي',
      subtitle: 'اعرف موقع الحافلة بدقة قبل الوصول إلى المحطة.',
      icon: Icons.location_on,
    ),
    _OnboardingPageData(
      title: 'أسعار ديناميكية مناسبة',
      subtitle: 'احصل على السعر الحقيقي بناءً على المسافة والوقت.',
      icon: Icons.price_change,
    ),
    _OnboardingPageData(
      title: 'رحلة سلسة من الصعود إلى الوصول',
      subtitle: 'تجربة ذكية ومريحة للمسافرين والسائقين والمدير.',
      icon: Icons.directions_bus,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _index = value),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Icon(
                            item.icon,
                            color: AppTheme.primary,
                            size: 60,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _index == i ? 24 : 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _index == i
                              ? AppTheme.primary
                              : AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_index < _pages.length - 1)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(AppStrings.skip),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (_index < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        return;
                      }
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      _index == _pages.length - 1
                          ? AppStrings.start
                          : AppStrings.next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
