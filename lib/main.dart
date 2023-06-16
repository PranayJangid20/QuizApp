import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prepaud/features/home/cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepaud/features/home/presentation/home_page.dart';
import 'package:prepaud/features/test/cubit/test_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:prepaud/utils/locator.dart';
import 'firebase_options.dart';

GetIt locator = GetIt.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLocator();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (BuildContext context) => HomeCubit(),
    ),
    BlocProvider(
      create: (BuildContext context) => TestCubit(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PrepAud Quiz',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}
