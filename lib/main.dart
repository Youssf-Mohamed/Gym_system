import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/bloc/cubit.dart';
import 'package:gym/const.dart';
import 'package:gym/screens/dashboard_screen.dart';
import 'package:gym/screens/login_screen.dart';
import 'package:gym/shared/components.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import 'bloc/states.dart';

void main()async {
  // 1. Ensure the Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  if(onlineMode==false)
    {
      await startPocketBase(); // Start PocketBase
      setupExitHook();           // Handle shutdown gracefully
    }
  // 2. Initialize the window manager
  await windowManager.ensureInitialized();

  // 3. Set your desired window options
  WindowOptions windowOptions = const WindowOptions(
    center: true,                 // Center the window on the screen
    minimumSize: Size(1200, 1000),    // Set the minimum window size
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'FitTrack'
  );
  // 4. Wait for the window to be ready, then apply the options
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();
   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>AppCubit()..checkSystem(NavigatorKey:navigatorKey),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {
        },
        builder: (context, state) {
          var cubit=AppCubit.get(context);
          return MaterialApp(
            navigatorKey: navigatorKey,
            theme: ThemeData(
              dialogTheme: DialogThemeData(
                backgroundColor: Color.fromRGBO(54, 54, 54, 1),
              ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                //colorScheme: ColorScheme.fromSeed( primary: Color.fromRGBO(26,26,26, 1), seedColor: Color.fromRGBO(26,26,26, 1),secondary: Color.fromRGBO(26,26,26, 1),brightness: Brightness.dark, ),
                iconButtonTheme: IconButtonThemeData(
                    style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white),)
                ),
                inputDecorationTheme: InputDecorationTheme(
                    fillColor: Color.fromRGBO(54, 54, 54, 1),
                    errorStyle: TextStyle(fontSize: 13),
                    prefixIconColor: Colors.white60,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black.withAlpha(0))
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black.withAlpha(0))
                    ),
                    hintStyle: TextStyle(color: Colors.white60)
                ),
                primaryColor: Color.fromRGBO(26,26,26, 1),
                textTheme: TextTheme(
                    bodySmall: TextStyle(color: Colors.white,fontSize: 25)
                ),
                scaffoldBackgroundColor: Color.fromRGBO(26,26,26, 1),
                appBarTheme: AppBarTheme(
                    color: Colors.transparent
                )
            ),
            home: cubit.stopType>0?Scaffold(body: Center(child: Text("${stopText(type: cubit.stopType)}",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w800),)),):LoginScreen(navigatorKey: navigatorKey,),
          );
        },
      ),
    );
  }
}