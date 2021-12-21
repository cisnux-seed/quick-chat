import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quick_chat/domain/usecases/local_data_picker.dart';
import '../../dummy/dummy_objects.dart';
import '../../dummy/mock_helper.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late LocalDataPicker localDataPicker;

  setUpAll(() {
    mockRepository = MockRepository();
    localDataPicker = LocalDataPicker(mockRepository);
  });

  test(
    'should return image path model when select image from local is successful',
    () async {
      when(mockRepository.pickImage())
          .thenAnswer((_) async => Right(imagePath));

      final result = await localDataPicker.execute();

      expect(result, Right(imagePath));
    },
  );
}
