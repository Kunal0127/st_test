import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCodeCubit extends Cubit<String> {
  EmployeeCodeCubit() : super('');

  void updateCode(String code) => emit(code);
}