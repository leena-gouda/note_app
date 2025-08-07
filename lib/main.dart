import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bloc_observer.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/notification_service.dart';
import 'features/home/data/repos/note_repo_imp.dart';
import 'features/home/ui/cubit/note_cubit.dart';
import 'firebase_options.dart';


bool isLogin = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 إشعار من الخلفية: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await isLoggedIn();

  await NotificationService.init(); // دي اللي هنشرحها دلوقتي

  Bloc.observer = AppBlocObserver();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) =>
          BlocProvider(
            create: (context) =>   NoteCubit(NoteRepoImpl())..getUserData(),
            child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: AppColor.backgroundColor,
                appBarTheme: AppBarTheme(
                  backgroundColor: AppColor.backgroundColor,
                  foregroundColor: Colors.black,
                  elevation: 0.0,
                ),
                useMaterial3: true,
                fontFamily: GoogleFonts
                    .nunitoSans()
                    .fontFamily,
              ),
              initialRoute: isLogin == true ? Routes.homeScreen : Routes
                  .onboardingScreen,
              onGenerateRoute: appRouter.generateRoute,
            ),
          ),
    );
  }
}

isLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString("email");
  if (email != null && email.isNotEmpty) {
    isLogin = true;
  } else {
    isLogin = false;
  }
}