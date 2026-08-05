import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/home_filled_body_widget.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/settings_body.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/streaming_list_widget.dart';
import 'package:subscription_management/src/modules/login/presentation/cubit/user_authentication_cubit.dart';
import 'package:subscription_management/src/routes/router.dart';
import 'package:subscription_management/src/utils/app_strings.dart';
import 'package:subscription_management/src/utils/widgets/custom_snack_bar_widget.dart';

@RoutePage(name: 'HomePageRoute')
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = SubscriptionsManagementStrings();
    return BlocProvider.value(
      value: GetIt.I.get<UserAuthenticationCubit>()..checkAuthentication(),
      child: BlocConsumer<UserAuthenticationCubit, UserAuthenticationState>(
        listener: (context, state) {
          state.when(
            onFailure: (error) {
              CustomSnackBar.showError(
                context,
                message: strings.somethingWentWrong,
              );
            },
            onInitial: () {
              if (context.router.canPop()) {
                context.router.popUntilRoot();
              }
              context.router.replace(SelectLoginMethodRoute());
            },
            onLoading: () {},
            onSuccess: (user) {},
          );
        },
        builder: (context, state) {
          return state.when(
            onSuccess: (user) {
              final userName = user.name;
              return SafeArea(
                child: Scaffold(
                  endDrawer: SettingsBody(
                    userName: userName,
                    onLogout: () {
                      context.read<UserAuthenticationCubit>().logout();
                    },
                  ),
                  backgroundColor: const Color.fromRGBO(243, 243, 243, 1),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userName ?? strings.welcome,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color.fromRGBO(111, 86, 221, 1),
                        ),
                      ),
                    ),
                    actions: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Color.fromRGBO(111, 86, 221, 1),
                          ),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
                    backgroundColor: const Color.fromRGBO(243, 243, 243, 1),
                    elevation: 0,
                  ),
                  body: const HomeFilledBodyWidget(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => context.router.navigate(
                      const SelectStreamingPageRoute(),
                    ),
                    backgroundColor: const Color.fromRGBO(111, 86, 221, 1),
                    child: Icon(
                      Icons.add,
                      color: const Color.fromRGBO(243, 243, 243, 1),
                      size: 48.sp,
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                ),
              );
            },
            onLoading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            onInitial: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            onFailure: (error) => Scaffold(body: StreamingsErrorWidget()),
          );
        },
      ),
    );
  }
}
