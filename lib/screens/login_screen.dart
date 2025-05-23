import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../cubits/camera_cubit.dart';
import '../cubits/employee_code_cubit.dart';
import '../blocs/upload_bloc.dart';
import '../blocs/upload_event.dart';
import '../blocs/upload_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _selectedAction;
  bool _isSubmitted = false;

  void _handleAction(BuildContext context, String action) async {
    try {
      final controller = context.read<CameraCubit>().state;
      final employeeCode = context.read<EmployeeCodeCubit>().state;

      dev.log("controller $controller");
      dev.log("employeeCode $employeeCode");

      if (controller != null &&
          controller.value.isInitialized &&
          employeeCode.isNotEmpty) {
        final picture = await controller.takePicture();
        dev.log("picture ${picture.path}");

        // ignore: use_build_context_synchronously
        context.read<UploadBloc>().add(
              UploadFileEvent(
                filePath: picture.path,
                employeeCode: employeeCode,
                action: action,
              ),
            );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Enter employee code & wait for camera.")),
        );
      }
    } catch (error) {
      dev.log("error : $error");
    } finally {
      setState(() {
        _isSubmitted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            bottom: -90,
            left: -90,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFFF5638)),
            ),
          ),
          Positioned(
            right: -90,
            top: -90,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFFF5638)),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocListener<UploadBloc, UploadState>(
              listener: (context, state) {
                dev.log(state.toString());
                if (state is UploadSuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is UploadFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: BlocBuilder<CameraCubit, CameraController?>(
                          builder: (context, controller) {
                            if (controller != null &&
                                controller.value.isInitialized) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: MediaQuery.of(context).size.width * 0.6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: CameraPreview(controller),
                                ),
                              ); // Show the camera feed
                            }
                            return const Center(
                                child:
                                    CircularProgressIndicator()); // Loading indicator
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Employee Code",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Employee Code",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) =>
                            context.read<EmployeeCodeCubit>().updateCode(value),
                      ),

                      const SizedBox(height: 20),
                      // Submit Button
                      if (!_isSubmitted)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isSubmitted = true;
                              });
                            },
                            child: const Text("Submit"),
                          ),
                        ),

                      if (_isSubmitted) ...[
                        // const Text(
                        //   "Select Action",
                        //   style: TextStyle(color: Colors.white),
                        // ),
                        CheckboxListTile(
                          title: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _selectedAction == 'login',
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedAction = value == true ? 'login' : null;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            "Break In",
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _selectedAction == 'breakin',
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedAction =
                                  value == true ? 'breakin' : null;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            "Break Out",
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _selectedAction == 'breakout',
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedAction =
                                  value == true ? 'breakout' : null;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _selectedAction == 'logout',
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedAction = value == true ? 'logout' : null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_selectedAction != null) {
                                _handleAction(context, _selectedAction!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please select an action")),
                                );
                              }
                            },
                            child: const Text("Submit Action"),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
