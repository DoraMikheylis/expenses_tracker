import 'package:expenses_tracker/app.dart';
import 'package:expenses_tracker/data/data_providers/firebase_options.dart';
import 'package:expenses_tracker/business_logic/utilities/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}
