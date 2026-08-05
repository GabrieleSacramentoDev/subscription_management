import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:subscription_management/src/modules/login/domain/entities/user_authentication_entity.dart';
import 'package:subscription_management/src/modules/login/presentation/cubit/user_authentication_cubit.dart';
import 'package:subscription_management/src/modules/shared/widgets/custom_app_bar.dart';
import 'package:subscription_management/src/modules/shared/widgets/custom_button.dart';
import 'package:subscription_management/src/modules/shared/widgets/custom_form.dart';
import 'package:subscription_management/src/modules/shared/widgets/loading_button.dart';
import 'package:subscription_management/src/routes/router.dart';
import 'package:subscription_management/src/utils/app_strings.dart';
import 'package:subscription_management/src/utils/widgets/custom_snack_bar_widget.dart';

@RoutePage(name: 'LoginPageRoute')
class LoginPage extends StatefulWidget {
  final bool isFromSignUp;
  const LoginPage({super.key, required this.isFromSignUp});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final strings = SubscriptionsManagementStrings();

  bool isPasswordVisible = false;

  _navigateToHomePage(String? email) {
    context.replaceRoute(const HomePageRoute());
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<UserAuthenticationCubit>();
      final entity = UserAuthenticationEntity(
        email: emailController.text,
        password: passwordController.text,
        name: widget.isFromSignUp ? nameController.text : null,
      );

      if (widget.isFromSignUp) {
        cubit.signup(entity);
      } else {
        cubit.signIn(entity);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void clearForm() {
    _formKey.currentState?.reset();
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I.get<UserAuthenticationCubit>(),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              appBarTitle: widget.isFromSignUp
                  ? strings.createAccount
                  : strings.enter,
              isBackButtonVisible: true,
              backgroundColor: Colors.white,
              appBarTitleColor: const Color.fromRGBO(111, 86, 221, 1),
              appBarIconColor: const Color.fromRGBO(111, 86, 221, 1),
              onBackButtonPressed: () => Navigator.pop(context),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 32.w,
                  top: 24.h,
                  bottom: 32.h,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          widget.isFromSignUp
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: CustomForm(
                                    semanticLabel: strings.name,
                                    isMandatory: true,
                                    hintText: strings.name,
                                    controller: nameController,
                                    label: strings.name,

                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return strings.thisFieldIsRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          CustomForm(
                            semanticLabel: strings.email,
                            isMandatory: true,
                            controller: emailController,
                            hintText: 'Email',
                            label: 'Email',
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return strings.thisFieldIsRequired;
                              }
                              if (!validator.isEmail(text)) {
                                return 'Email inválido';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                            child: CustomForm(
                              semanticLabel: strings.password,
                              isMandatory: true,
                              obscurePassword: isPasswordVisible,
                              hintText: strings.password,
                              controller: passwordController,
                              label: strings.password,
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                  () => isPasswordVisible = !isPasswordVisible,
                                ),
                                child: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return strings.thisFieldIsRequired;
                                }
                                if (text.length < 8) {
                                  return strings.passwordMustBeAtLeast;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<
                      UserAuthenticationCubit,
                      UserAuthenticationState
                    >(
                      listener: (context, state) async {
                        if (state.isFailure) {
                          CustomSnackBar.showError(
                            context,
                            message: strings.wasNotPossibleToCreateAnAccount,
                          );
                        } else if (state.isSuccess) {
                          final email = emailController.text;

                          _navigateToHomePage(email);
                          clearForm();
                        }
                      },
                      builder: (context, state) {
                        return state.isLoading
                            ? const LoadingButton(isLarge: true)
                            : CustomButton(
                                textButton: strings.enter,
                                onPressed: () => _handleLogin(context),
                                isLarge: true,
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
