import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quick_chat/presentation/cubit/auth_cubit.dart';
import 'package:quick_chat/presentation/widgets/build_login_illustration.dart';
import 'package:quick_chat/utils/app_routes.dart';

class MobileRegisterView extends StatefulWidget {
  const MobileRegisterView({Key? key}) : super(key: key);

  @override
  State<MobileRegisterView> createState() => _MobileRegisterViewState();
}

class _MobileRegisterViewState extends State<MobileRegisterView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (_, state) =>
                state is RegisterSuccess || state is RegisterError,
            listener: (_, state) {
              if (state is RegisterSuccess) {
                Get.offAllNamed(kMobileCreateProfileView);
              } else if (state is RegisterError) {
                Get.defaultDialog(
                  title: 'Register',
                  content: Text(state.message, textAlign: TextAlign.center),
                  textConfirm: 'Ok',
                  onConfirm: () => Get.back(),
                );
              }
            },
            builder: (context, state) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BuildLoginIllustration(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(320, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          }
                        },
                        child: const Text('Create an Account'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Have an account? ",
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                "Sign in",
                                style: context.textTheme.bodyText2!
                                    .copyWith(color: Colors.blue.shade900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
