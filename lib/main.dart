import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_test/blocs/upload_bloc.dart';
import 'package:st_test/cubits/camera_cubit.dart';
import 'package:st_test/cubits/employee_code_cubit.dart';
import 'package:st_test/screens/login_screen.dart';
import 'package:st_test/service/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CameraCubit()..initializeCamera()),
        BlocProvider(create: (_) => EmployeeCodeCubit()),
        BlocProvider(create: (_) => UploadBloc(ApiService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
