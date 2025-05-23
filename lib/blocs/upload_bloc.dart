import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_test/service/api_service.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ApiService apiService;

  UploadBloc(this.apiService) : super(UploadInitial()) {
    on<UploadFileEvent>(_onUploadFile);
  }

  Future<void> _onUploadFile(
    UploadFileEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadLoading());
    try {
      final message = await apiService.uploadFile(
        filePath: event.filePath,
        employeeCode: event.employeeCode,
        action: event.action,
      );
      emit(UploadSuccess(message));
    } catch (e) {
      print("object $e");
      emit(UploadFailure(e.toString()));
    }
  }
}
