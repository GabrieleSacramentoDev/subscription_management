import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:subscription_management/src/modules/login/presentation/cubit/user_authentication_cubit.dart';
import 'package:subscription_management/src/routes/router.dart';

@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final checkAuthentication = GetIt.I.get<UserAuthenticationCubit>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward().then((_) {
        checkAuthentication.checkAuthentication();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _navigateToSelectLoginMethodPage() {
    context.pushRoute(SelectLoginMethodRoute());
  }

  _navigateToHomePage() {
    context.pushRoute(const HomePageRoute());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => checkAuthentication,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(228, 228, 237, 1),
        body: BlocListener<UserAuthenticationCubit, UserAuthenticationState>(
          listener: (context, state) {
            if (state.isInitial) {
              _navigateToSelectLoginMethodPage();
            } else if (state.isSuccess) {
              _navigateToHomePage();
            } else if (state.isFailure) {
              _navigateToSelectLoginMethodPage();
            }
          },
          child: Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 200 * (1 - _animation.value)),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/subscription_management_logo.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
