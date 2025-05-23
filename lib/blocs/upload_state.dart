import 'package:equatable/equatable.dart';

abstract class UploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class UploadSuccess extends UploadState {
  final String message;

  UploadSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UploadFailure extends UploadState {
  final String error;

  UploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
