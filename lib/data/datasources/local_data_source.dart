import 'package:image_picker/image_picker.dart';
import 'package:quick_chat/utils/exceptions.dart';

abstract class LocalDataSource {
  Future<String?> pickImage();
}

class LocalDataSourceImpl extends LocalDataSource {
  LocalDataSourceImpl({required this.imagePicker});

  final ImagePicker imagePicker;

  @override
  Future<String?> pickImage() async {
    try {
      final result = await ImagePicker().pickImage(
        imageQuality: 60,
        maxWidth: 720,
        source: ImageSource.gallery,
      );

      if (result != null) {
        return result.path;
      } else {
        return null;
      }
    } catch (e) {
      throw DataPickerException('failed');
    }
  }
}
