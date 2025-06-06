import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/controllers/auth_controller.dart';
import 'package:weatherapp/controllers/theme_controller.dart';
import 'package:weatherapp/helper/notification_services.dart';
import 'package:weatherapp/provider/weatherProvider.dart';
import 'package:weatherapp/screens/splash_screen/splash_screen_main.dart';
import 'package:weatherapp/screens/weather/cyclone_detection.dart';
import 'package:weatherapp/utils/app_themes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: AppThemes().lightTheme,
        darkTheme: AppThemes().darkTheme,
        themeMode: ThemeController().theme,
        home: SplashScreen(),
      ),
    );
  }
}
