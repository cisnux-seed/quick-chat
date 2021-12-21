import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_chat/styles/colors.dart';

class DesktopLoginView extends StatelessWidget {
  const DesktopLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: context.theme.colorScheme.primary,
              child: Stack(
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage("assets/images/login.png"),
                      width: 500,
                      height: 500,
                    ),
                  ),
                  Positioned(
                    top: 323,
                    right: 68,
                    child: Text(
                      "Quick Chat",
                      style: context.textTheme.headline4!.copyWith(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 140),
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: context.textTheme.headline6!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    'Login to your account',
                    style: context.textTheme.headline4!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Email',
                    style: context.textTheme.headline6!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        hintText: 'Email Address',
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Password',
                    style: context.textTheme.headline6!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          color: context.theme.colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.visibility_rounded,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 400,
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: context.textTheme.bodyText1!
                          .copyWith(color: Colors.blue.shade900),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Login Now'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(400, 50),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset('assets/images/google_icon.png'),
                        ),
                        const SizedBox(width: 8),
                        const Text('Or Sign-in with Google'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(400, 50),
                      primary: kGoogleButtonSignInColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
