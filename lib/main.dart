import 'package:awesome_notifications/awesome_notifications.dart';
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
  runApp(const MonefyApp());
}

class MonefyApp extends StatelessWidget {
  const MonefyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavingsProvider()..loadData(),
      child: Consumer<SavingsProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Monefy',
            debugShowCheckedModeBanner: false,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              fontFamily: 'Poppins',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0D1B3E),
                primary: const Color(0xFF0D1B3E),
              ),
              scaffoldBackgroundColor: const Color(0xFFF5F5F0),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              fontFamily: 'Poppins',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0D1B3E),
                primary: const Color(0xFF0D1B3E),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF0A0F1E),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}