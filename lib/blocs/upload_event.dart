import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadFileEvent extends UploadEvent {
  final String filePath;
  final String employeeCode;
  final String action; // login, breakin, breakout, logout

  UploadFileEvent({
    required this.filePath,
    required this.employeeCode,
    required this.action,
  });

  @override
  List<Object> get props => [filePath, employeeCode, action];
}
