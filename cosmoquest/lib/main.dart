import 'package:cosmoquest/Service/no_internet_page.dart';
import 'package:cosmoquest/Service/network_controller.dart';
import 'package:cosmoquest/Utils/Color/colors.dart';
import 'package:cosmoquest/ViewModel/ExoplanetModel/apod_view_model.dart';
import 'package:cosmoquest/ViewModel/GameQuiz/quiz_view_model.dart';
import 'package:cosmoquest/ViewModel/Game_2/learning_viewmodel.dart';
import 'package:cosmoquest/ViewModel/Leaderborad/leaderboard_view_model.dart';
import 'package:cosmoquest/ViewModel/SignUpViewModel.dart';
import 'package:cosmoquest/ViewModel/bottom_navigation_viewmodel.dart';
import 'package:cosmoquest/ViewModel/home_viewmodel.dart';
import 'package:cosmoquest/ViewModel/login_viewmodel.dart';
import 'package:cosmoquest/view/Auth/Authentication.dart';
import 'package:cosmoquest/view/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InternetController(), permanent: true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider<HomeViewModel>(create: (_) => HomeViewModel()),
          ChangeNotifierProvider<LoginViewModel>(
              create: (_) => LoginViewModel()),
          ChangeNotifierProvider<SignUpViewModel>(
              create: (_) => SignUpViewModel()),
          ChangeNotifierProvider<BottomNavigationViewModel>(
              create: (_) => BottomNavigationViewModel()),
          ChangeNotifierProvider(create: (_) => QuizViewModel()),
          ChangeNotifierProvider(create: (_) => LearningViewModel()),
          ChangeNotifierProvider(create: (_) => LeaderboardViewModel()),
          ChangeNotifierProvider(create: (_) => APODViewModel()),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: const ColorScheme.dark(),
            useMaterial3: true,
          ),
          home: const AuthenticationCheck(),
        ));
  }
}
