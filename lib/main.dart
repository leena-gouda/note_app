// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'app_bloc_observer.dart';
// import 'core/routing/app_router.dart';
// import 'core/routing/routes.dart';
// import 'core/theme/app_colors.dart';
// import 'core/utils/notification_service.dart';
// import 'features/home/data/repos/note_repo_imp.dart';
// import 'features/home/ui/cubit/note_cubit.dart';
// import 'firebase_options.dart';
//
//
// bool isLogin = false;
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('📩 Background notification: ${message.notification?.title}');
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await isLoggedIn();
//
//   await NotificationService.init();
//
//   Bloc.observer = AppBlocObserver();
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   runApp(MyApp(appRouter: AppRouter()));
// }
//
// class MyApp extends StatelessWidget {
//   final AppRouter appRouter;
//
//   const MyApp({super.key, required this.appRouter});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(390, 844),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) =>
//           BlocProvider(
//             create: (context) =>   NoteCubit(NoteRepoImpl())..getUserData(),
//             child: MaterialApp(
//               title: 'Flutter Demo',
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                 scaffoldBackgroundColor: AppColor.backgroundColor,
//                 appBarTheme: AppBarTheme(
//                   backgroundColor: AppColor.backgroundColor,
//                   foregroundColor: Colors.black,
//                   elevation: 0.0,
//                 ),
//                 useMaterial3: true,
//                 fontFamily: GoogleFonts
//                     .nunitoSans()
//                     .fontFamily,
//               ),
//               initialRoute: isLogin == true ? Routes.homeScreen : Routes
//                   .onboardingScreen,
//               onGenerateRoute: appRouter.generateRoute,
//             ),
//           ),
//     );
//   }
// }
//
// isLoggedIn() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? email = prefs.getString("email");
//   if (email != null && email.isNotEmpty) {
//     isLogin = true;
//   } else {
//     isLogin = false;
//   }
// }

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/features/add_edit/data/repos/add_edit_repo_impl.dart';
import 'package:note_app/features/add_edit/ui/cubit/add_edit_cubit.dart';
import 'package:note_app/features/deleted/ui/cubit/deleted_cubit.dart';
import 'package:note_app/features/favorites/data/repos/favorite_repo.dart';
import 'package:note_app/features/favorites/data/repos/favorite_repo_impl.dart';
import 'package:note_app/features/favorites/ui/cubit/favorite_cubit.dart';
import 'package:note_app/features/hidden/data/repos/hidden_repo_impl.dart';
import 'package:note_app/features/hidden/ui/cubit/hidden_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bloc_observer.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/notification_service.dart';
import 'features/home/data/repos/note_repo_imp.dart';
import 'features/home/ui/cubit/navigation_cubit.dart';
import 'features/home/ui/cubit/note_cubit.dart';
import 'features/Search/ui/cubit/search_cubit.dart';
import 'firebase_options.dart';

bool isLogin = false;
bool _initialized = false;

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background notification: ${message.notification?.title}');
  // Add your background notification handling here
}

void main() {
  // Show splash screen immediately
  runApp(const SplashScreen());

  // Then initialize everything in background
  _initializeApp().then((_) {
    runApp(MyApp(appRouter: AppRouter()));
  });
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase and login status in parallel
    await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      _checkLoginStatus(),
    ]);

    // Initialize notifications with retry
    await _initNotifications();

    // Initialize BLoC observer
    Bloc.observer = AppBlocObserver();

    print('✅ App initialization complete');
  } catch (e) {
    print('🔥 Initialization error: $e');
  }
}

Future<void> _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getString("email")?.isNotEmpty == true;
}

Future<void> _initNotifications() async {
  if (_initialized) return;
  _initialized = true;

  try {
    final messaging = FirebaseMessaging.instance;

    unawaited(messaging.requestPermission().then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notification permissions granted');
      }
    }));

    messaging.getToken().then((token) => print('📱 Device token: $token'));

    FirebaseMessaging.onMessage.listen((message) {
      print('📩 Foreground notification: ${message.notification?.title}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    print('🔔 Notifications initialized');
  } catch (e) {
    print('⚠️ Notification initialization failed: $e');
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColor.primaryColor),
              SizedBox(height: 20),
              Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(create: (context) => NoteCubit(NoteRepoImpl())..getUserData(),),
          BlocProvider(create: (_) => SearchCubit()),
          BlocProvider(create: (context) => FavoriteCubit(FavoriteRepoImpl(), NoteRepoImpl())),
          BlocProvider(create: (context) => AddEditCubit(AddEditRepoImpl())),
          BlocProvider(create: (context) => HiddenCubit(NoteRepoImpl())),
          BlocProvider(create: (context) => DeletedCubit(NoteRepoImpl())),

        ],
        child: MaterialApp(
          title: 'Your App Name',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.backgroundColor,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColor.backgroundColor,
              foregroundColor: Colors.black,
              elevation: 0.0,
            ),
            useMaterial3: true,
            fontFamily: GoogleFonts.nunitoSans().fontFamily,
          ),
          initialRoute: isLogin ? Routes.homeScreen : Routes.onboardingScreen,
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );
  }
}