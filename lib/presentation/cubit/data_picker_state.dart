part of 'data_picker_cubit.dart';

abstract class DataPickerState extends Equatable {
  const DataPickerState();

  @override
  List<Object?> get props => [];
}

class DataPickerEmpty extends DataPickerState {}

class ImagePickerLoading extends DataPickerState {}

class ImagePickerError extends DataPickerState {
  final String message;

  const ImagePickerError(this.message);

  @override
  List<Object> get props => [message];
}

class ImagePickerSuccess extends DataPickerState {
  final String? imagePath;

  const ImagePickerSuccess(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}
