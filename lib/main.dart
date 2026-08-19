import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'di/injection.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/trip/presentation/bloc/trip_bloc.dart';
import 'features/user/presentation/bloc/user_data_bloc.dart';
import 'firebase_options.dart';
import 'presentation/navigation/app_router.dart';
import 'providers/language_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const NavioApp());
}

class NavioApp extends StatelessWidget {
  const NavioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ...[
          BlocProvider<AuthBloc>(
            create: (_) => di.sl<AuthBloc>()..add(AppStarted()),
          ),
          BlocProvider<TripBloc>(create: (_) => di.sl<TripBloc>()),
          BlocProvider<UserDataBloc>(create: (_) => di.sl<UserDataBloc>()),
        ],
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, language, _) {
          final isArabic = language.locale.languageCode == 'ar';

          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            locale: language.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            theme: AppTheme.lightTheme,
            builder: (context, child) {
              return Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: '/splash',
          );
        },
      ),
    );
  }
}
