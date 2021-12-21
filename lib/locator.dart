import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_chat/data/datasources/local_data_source.dart';
import 'package:quick_chat/data/datasources/remote_data_source.dart';
import 'package:quick_chat/data/repository/repository_impl.dart';
import 'package:quick_chat/domain/repository/repository.dart';
import 'package:quick_chat/domain/usecases/auth.dart';
import 'package:quick_chat/domain/usecases/create_room.dart';
import 'package:quick_chat/domain/usecases/create_user_profile.dart';
import 'package:quick_chat/domain/usecases/get_chat_rooms.dart';
import 'package:quick_chat/domain/usecases/get_messages.dart';
import 'package:quick_chat/domain/usecases/get_users.dart';
import 'package:quick_chat/domain/usecases/get_user_profile.dart';
import 'package:quick_chat/domain/usecases/local_data_picker.dart';
import 'package:quick_chat/domain/usecases/send_message.dart';
import 'package:quick_chat/domain/usecases/update_user_profile.dart';
import 'package:quick_chat/presentation/cubit/auth_cubit.dart';
import 'package:quick_chat/presentation/cubit/create_room_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_chat_rooms_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_current_user_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_messages_cubit.dart';
import 'package:quick_chat/presentation/cubit/search_account_cubit.dart';
import 'package:quick_chat/presentation/cubit/data_picker_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_user_profile_cubit.dart';
import 'package:quick_chat/presentation/cubit/send_message_cubit.dart';
import 'package:quick_chat/presentation/cubit/update_user_profile_cubit.dart';

final locator = GetIt.instance;

void init() {
  // cubit
  locator.registerFactory(
    () => AuthCubit(
      auth: locator(),
      createUserProfile: locator(),
    ),
  );
  locator.registerFactory(() => GetUserProfileCubit(locator()));
  locator.registerFactory(() => UpdateUserProfileCubit(locator()));
  locator.registerFactory(() => GetChatRoomsCubit(locator()));
  locator.registerFactory(() => GetMessagesCubit(locator()));
  locator.registerFactory(() => SendMessageCubit(sendMessage: locator()));
  locator.registerFactory(() => DataPickerCubit(locator()));
  locator.registerFactory(() => SearchAccountCubit(locator()));
  locator.registerFactory(() => CreateRoomCubit(locator()));

  // usecases
  locator.registerLazySingleton(() => GetCurrentUserCubit(locator()));
  locator.registerLazySingleton(() => GetChatRooms(locator()));
  locator.registerLazySingleton(() => CreateUserProfile(locator()));
  locator.registerLazySingleton(() => UpdateUserProfile(locator()));
  locator.registerLazySingleton(
    () => Auth(firebaseAuth: locator(), googleAuth: locator()),
  );
  locator.registerLazySingleton(
    () => GetUserProfile(locator()),
  );
  locator.registerLazySingleton(
    () => GetMessages(locator()),
  );
  locator.registerLazySingleton(
    () => CreateRoom(locator()),
  );
  locator.registerLazySingleton(() => LocalDataPicker(locator()));
  locator.registerLazySingleton(() => SendMessage(locator()));
  locator.registerLazySingleton(() => GetUsers(locator()));

  // repository
  locator.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // datasources
  locator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(imagePicker: locator()),
  );
  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(
      firestore: locator(),
      firebaseStorage: locator(),
    ),
  );

  // firebase
  locator.registerLazySingleton<ImagePicker>(() => ImagePicker());
  locator.registerLazySingleton<FirebaseStorage>(
    () => FirebaseStorage.instance,
  );
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
}
