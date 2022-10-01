import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_ordering_app/router/app_router.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:meal_ordering_app/features/authentication/bloc/authentication_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isValidEmail(String text) {
    final emailRegExp = RegExp(
        r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""");
    // final isKuartisEmail =
    //     text.endsWith('@kuartis.com') || text.endsWith('@kuartismed.com');
    final isKuartisEmail = true;
    return emailRegExp.hasMatch(text) && isKuartisEmail;
  }

  bool isConfirmPasswordSame() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  bool isValidPassword(password) {
    return password.length >= 8; // TODO: Improve this
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is WaitLoggingIn) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: AlertDialog(
                        title: Text(
                          tr('lbl_logging_in'),
                          textAlign: TextAlign.center,
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [CircularProgressIndicator()],
                        )),
                  ));
        } else if (state is LoggingInFailed) {
          // TODO : Fail
        } else if (state is LoggedIn) {
          context.router
              .pushAndPopUntil(const HomeRoute(), predicate: (_) => false);
        }
      },
      builder: (context, state) {
        return LayoutBuilder(builder: (context, constraints) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: tr('lbl_email'),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) => isValidEmail(value ?? '')
                                ? null
                                : tr('lbl_email_not_valid'),
                          ),
                          SizedBox(height: 4.w),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: tr('lbl_password'),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) => isValidPassword(value)
                                ? null
                                : tr('lbl_password_not_valid'),
                          ),
                          SizedBox(height: 2.w),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: tr('lbl_confirm_password'),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: (value) => isConfirmPasswordSame()
                                ? null
                                : tr('lbl_passwords_not_match'),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              context.router.replace(const LoginRoute());
                            },
                            child: Text(tr('lbl_already_have_account'),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                          SizedBox(height: 5.w),
                          SizedBox(
                              height: 5.w,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(
                                        Register(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(tr('lbl_register'))))
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
