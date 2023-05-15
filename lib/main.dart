import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/admin_screens/admin_otp_screen.dart';
import 'package:wash_mesh/admin_screens/total_bookings.dart';
import 'package:wash_mesh/admin_screens/total_earnings.dart';
// import 'package:wash_mesh/admin_screens/admin_home_screen.dart';
// import 'package:wash_mesh/admin_screens/admin_registration_form.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/providers/admin_provider/admin_info_provider.dart';
import 'package:wash_mesh/providers/user_provider/user_auth_provider.dart';
import 'package:wash_mesh/providers/user_provider/user_info_provider.dart';
// import 'package:wash_mesh/slider/controller.dart';
// import 'package:wash_mesh/slider/slider_home.dart';
import 'package:wash_mesh/splash_screen.dart';
import 'package:wash_mesh/user_screens/accepted_orders_screen.dart';
import 'package:wash_mesh/user_screens/prefrence.dart';

import 'admin_screens/admin_accepted_order_screen.dart';
import 'admin_screens/admin_check_otp.dart';
import 'admin_screens/admin_orders_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyPrefferences.init();
  await Firebase.initializeApp(
    name: 'wash-mesh',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ur', 'PAK'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AdminAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminInfoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserInfoProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Wash Mesh',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
