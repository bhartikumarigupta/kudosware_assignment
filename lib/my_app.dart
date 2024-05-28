import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:student_management/screens/login_screens.dart';
import 'package:student_management/screens/signup_screen.dart';
import 'package:student_management/screens/main_screen.dart';
import 'package:student_management/repositories/auth_repository.dart';
import 'package:student_management/bloc/auth_bloc.dart';
import 'package:student_management/bloc/auth_state.dart';

class MyApp extends StatelessWidget {
  final AuthRepository authRepository =
      AuthRepository(firebaseAuth: FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: authRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthInitial) {
                    return LoginScreen();
                  } else if (state is AuthSuccess) {
                    return MainScreen();
                  } else if (state is AuthFailure) {
                    return LoginScreen();
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
          '/signup': (context) => SignupScreen(),
          '/home': (context) => MainScreen(),
        },
      ),
    );
  }
}
