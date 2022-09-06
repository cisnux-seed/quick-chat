import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_chat/domain/usecases/local_data_picker.dart';

part 'data_picker_state.dart';

class DataPickerCubit extends Cubit<DataPickerState> {
  DataPickerCubit(this.pickImage) : super(DataPickerEmpty());

  final LocalDataPicker pickImage;

  Future<void> pickImages() async {
    emit(ImagePickerLoading());
    final result = await pickImage.execute();

    result.fold(
      (failure) => emit(ImagePickerError(failure.message)),
      (success) => emit(ImagePickerSuccess(success)),
    );
  }

  void setStateToEmpty() => emit(DataPickerEmpty());
}
