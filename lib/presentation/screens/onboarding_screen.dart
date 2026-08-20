import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/space_background.dart';

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
      asset: 'assets/images/space/earth_americas.png',
    ),
    _OnboardingPageData(
      title: 'أسعار ديناميكية مناسبة',
      subtitle: 'احصل على السعر الحقيقي بناءً على المسافة والوقت.',
      icon: Icons.price_change,
      asset: 'assets/images/space/earth_africa.png',
    ),
    _OnboardingPageData(
      title: 'رحلة سلسة من الصعود إلى الوصول',
      subtitle: 'تجربة ذكية ومريحة للمسافرين والسائقين والمدير.',
      icon: Icons.directions_bus,
      asset: 'assets/images/space/earth_orbit.png',
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
      backgroundColor: Colors.transparent,
      body: SpaceBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildWelcomePage(context);
                    }
                    final item = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 190,
                              height: 190,
                              child: Image.asset(item.asset, fit: BoxFit.cover),
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
                    if (_index == 0) const SizedBox.shrink(),
                    if (_index != 0) ...[
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
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF020B15)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/space/stars.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 180,
            left: -70,
            right: -70,
            child: Image.asset(
              'assets/images/space/earth_orbit.png',
              height: 340,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, const Color(0xDD020B15)],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 284,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFEDF6FF),
                  size: 26,
                ),
                const SizedBox(width: 36),
                Container(
                  width: 181,
                  height: 181,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xCC102A43),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 10,
                        offset: Offset(4, 4),
                      ),
                      BoxShadow(
                        color: Color(0x66BDBDBD),
                        blurRadius: 10,
                        offset: Offset(-4, -4),
                      ),
                    ],
                  ),
                  child: Text(
                    AppStrings.appName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFEDF6FF),
                      fontSize: 52,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 81,
            right: 81,
            top: 506,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0x551B83D8),
                border: Border.all(color: const Color(0xFF52B8FF), width: 1.2),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Move with safety',
                    style: const TextStyle(
                      color: Color(0xFFEDF6FF),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFFEDF6FF),
                    size: 34,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 37,
            right: 37,
            bottom: 62,
            child: ElevatedButton.icon(
              onPressed: () => _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              icon: const Icon(Icons.arrow_forward, size: 28),
              label: Text(AppStrings.next),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xFFEDF6FF),
                shadowColor: Colors.black54,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String asset;

  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.asset,
  });
}
