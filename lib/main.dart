import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quick_chat/styles/colors.dart';
import 'package:quick_chat/styles/font_styles.dart';
import 'package:quick_chat/utils/app_routes.dart';
import 'package:quick_chat/locator.dart';
import 'package:quick_chat/presentation/cubit/data_picker_cubit.dart';
import 'package:quick_chat/presentation/cubit/auth_cubit.dart';
import 'package:quick_chat/presentation/cubit/search_account_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_user_profile_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_messages_cubit.dart';
import 'package:quick_chat/presentation/cubit/send_message_cubit.dart';
import 'package:quick_chat/presentation/cubit/create_room_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_current_user_cubit.dart';
import 'package:quick_chat/presentation/cubit/get_chat_rooms_cubit.dart';
import 'package:quick_chat/presentation/cubit/update_user_profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<AuthCubit>()),
        BlocProvider(create: (_) => locator<GetUserProfileCubit>()),
        BlocProvider(create: (_) => locator<GetMessagesCubit>()),
        BlocProvider(create: (_) => locator<DataPickerCubit>()),
        BlocProvider(create: (_) => locator<SearchAccountCubit>()),
        BlocProvider(create: (_) => locator<SendMessageCubit>()),
        BlocProvider(create: (_) => locator<CreateRoomCubit>()),
        BlocProvider(create: (_) => locator<GetChatRoomsCubit>()),
        BlocProvider(create: (_) => locator<GetCurrentUserCubit>()),
        BlocProvider(create: (_) => locator<UpdateUserProfileCubit>()),
      ],
      child: MaterialApp.router(
        // navigatorObservers: [kRouteObserver],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.green[200],
          ),
          primaryColor: kPrimaryColor,
          colorScheme: kColorScheme,
          textTheme: textTheme,
          backgroundColor: context.theme.colorScheme.onBackground,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: context.textTheme.bodyText1,
            ),
          ),
        ),
        title: 'Quick Chat',
        initialRoute: kSplashView,
        getPages: appViews,
      ),
    );
  }
}
