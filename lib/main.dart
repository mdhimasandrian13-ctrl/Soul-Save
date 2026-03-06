import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';
import 'providers/savings_provider.dart';
import 'notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await NotificationHelper.init();
  runApp(const SoulSaveApp());
}

class SoulSaveApp extends StatelessWidget {
  const SoulSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavingsProvider()..loadData(),
      child: Consumer<SavingsProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Soul Save',
            debugShowCheckedModeBanner: false,
            themeMode:
                provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              fontFamily: 'Poppins',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2EC4A0),
                primary: const Color(0xFF2EC4A0),
              ),
              scaffoldBackgroundColor: const Color(0xFFFDF6ED),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              fontFamily: 'Poppins',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2EC4A0),
                primary: const Color(0xFF2EC4A0),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF1A1A2E),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}