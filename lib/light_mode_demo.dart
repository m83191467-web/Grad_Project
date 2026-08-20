import 'package:flutter/material.dart';

void main() => runApp(const LightModeDemoApp());

class LightModeDemoApp extends StatelessWidget {
  const LightModeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF10233F);
    const blue = Color(0xFF2F6BFF);
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
      primary: blue,
      surface: const Color(0xFFF7F9FC),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
          titleLarge: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF69758A)),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 76,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE7EEFF),
          labelTextStyle: WidgetStatePropertyAll(
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      home: const RideHomeDemo(),
    );
  }
}

class RideHomeDemo extends StatefulWidget {
  const RideHomeDemo({super.key});

  @override
  State<RideHomeDemo> createState() => _RideHomeDemoState();
}

class _RideHomeDemoState extends State<RideHomeDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  )..forward();
  int _selectedNav = 0;
  int _selectedRide = 0;

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  void _openDestinationPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DestinationPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: CurvedAnimation(parent: _intro, curve: Curves.easeOut),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 700;
              final content = _HomeContent(
                onSearch: _openDestinationPicker,
                selectedRide: _selectedRide,
                onRideChanged: (value) => setState(() => _selectedRide = value),
              );
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: wide ? 980 : 620),
                  child: content,
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNav,
        onDestinationSelected: (value) => setState(() => _selectedNav = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.onSearch,
    required this.selectedRide,
    required this.onRideChanged,
  });

  final VoidCallback onSearch;
  final int selectedRide;
  final ValueChanged<int> onRideChanged;

  @override
  Widget build(BuildContext context) {
    final horizontal = MediaQuery.sizeOf(context).width >= 700;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(onProfile: () {}),
          const SizedBox(height: 24),
          Text(
            'Where are you going?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          _SearchCard(onTap: onSearch),
          const SizedBox(height: 18),
          _MapPreview(onTap: onSearch),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choose your ride',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 142,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _RideOption(
                index: index,
                selected: selectedRide == index,
                onTap: () => onRideChanged(index),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text('Upcoming ride', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _UpcomingRide(),
          if (horizontal) ...[
            const SizedBox(height: 24),
            const _QuickActions(),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onProfile});
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 3),
              Text(
                'Abdalrahman',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        GestureDetector(
          onTap: onProfile,
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFFDCE7FF),
            child: Text(
              'A',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF2F6BFF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF2F6BFF),
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Text(
                  'Search by pickup or destination',
                  style: TextStyle(color: Color(0xFF7D899C), fontSize: 14),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF9AA6B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          height: 210,
          child: Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
              Positioned(
                top: 18,
                right: 18,
                child: _MapButton(
                  icon: Icons.my_location_rounded,
                  onTap: onTap,
                ),
              ),
              const Positioned(bottom: 18, left: 18, child: _MapLegend()),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: const CircleBorder(),
    elevation: 2,
    child: IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: const Color(0xFF2F6BFF), size: 20),
    ),
  );
}

class _MapLegend extends StatelessWidget {
  const _MapLegend();
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 12)],
    ),
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Color(0xFFFF765C), size: 17),
          SizedBox(width: 6),
          Text(
            'Your current area',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

class _MapPainter extends CustomPainter {
  const _MapPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE9F2E9);
    canvas.drawRect(Offset.zero & size, background);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final accent = Paint()
      ..color = const Color(0xFFBFD9C2)
      ..strokeWidth = 2;
    final paths = [
      Path()
        ..moveTo(-20, 45)
        ..cubicTo(100, 20, 190, 115, size.width + 20, 75),
      Path()
        ..moveTo(70, -20)
        ..cubicTo(80, 65, 210, 140, 270, size.height + 20),
      Path()
        ..moveTo(size.width - 60, -20)
        ..cubicTo(
          size.width - 150,
          90,
          size.width - 75,
          145,
          size.width + 20,
          180,
        ),
    ];
    for (final path in paths) {
      canvas.drawPath(path, road);
      canvas.drawPath(path, accent);
    }
    final route = Path()
      ..moveTo(size.width * .2, size.height * .72)
      ..cubicTo(
        size.width * .38,
        size.height * .3,
        size.width * .65,
        size.height * .82,
        size.width * .82,
        size.height * .28,
      );
    canvas.drawPath(
      route,
      Paint()
        ..color = const Color(0xFF2F6BFF)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke,
    );
    for (final point in [
      Offset(size.width * .2, size.height * .72),
      Offset(size.width * .82, size.height * .28),
    ]) {
      canvas.drawCircle(point, 8, Paint()..color = Colors.white);
      canvas.drawCircle(point, 5, Paint()..color = const Color(0xFF2F6BFF));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RideOption extends StatelessWidget {
  const _RideOption({
    required this.index,
    required this.selected,
    required this.onTap,
  });
  final int index;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final names = ['Economy', 'Comfort', 'XL'];
    final prices = ['From 45 EGP', 'From 70 EGP', 'From 95 EGP'];
    final icons = [
      Icons.directions_car_filled_rounded,
      Icons.airport_shuttle_rounded,
      Icons.directions_car_filled_rounded,
    ];
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2F6BFF) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? const Color(0xFF2F6BFF) : const Color(0xFFE9EDF4),
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x332F6BFF),
                    blurRadius: 16,
                    offset: Offset(0, 7),
                  ),
                ]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icons[index],
              color: selected ? Colors.white : const Color(0xFF2F6BFF),
              size: 30,
            ),
            const Spacer(),
            Text(
              names[index],
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : const Color(0xFF10233F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              prices[index],
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white70 : const Color(0xFF7D899C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingRide extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.schedule_rounded, color: Color(0xFFFF815B)),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tomorrow, 08:30 AM',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10233F),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'New Cairo  •  Zamalek',
                  style: TextStyle(fontSize: 12, color: Color(0xFF7D899C)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA6B8)),
        ],
      ),
    ),
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();
  @override
  Widget build(BuildContext context) => Row(
    children: const [
      Expanded(
        child: _QuickAction(
          icon: Icons.bookmark_border_rounded,
          label: 'Saved places',
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: _QuickAction(
          icon: Icons.support_agent_rounded,
          label: 'Get support',
        ),
      ),
    ],
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2F6BFF)),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),
  );
}

class DestinationPickerSheet extends StatefulWidget {
  const DestinationPickerSheet({super.key});
  @override
  State<DestinationPickerSheet> createState() => _DestinationPickerSheetState();
}

class _DestinationPickerSheetState extends State<DestinationPickerSheet> {
  String query = '';
  final destinations = const [
    'Cairo Festival City',
    'Cairo International Airport',
    'Zamalek',
    'Maadi Grand Mall',
  ];
  @override
  Widget build(BuildContext context) {
    final results = destinations
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F9FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD7DDE8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Choose a destination',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF10233F),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            autofocus: true,
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'Type a place or route',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...results.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF2F6BFF),
              ),
              title: Text(
                item,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text('Cairo, Egypt'),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
