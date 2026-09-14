import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:subscription_management/src/modules/login/presentation/cubit/user_authentication_cubit.dart';
import 'package:subscription_management/src/routes/router.dart';
import 'package:subscription_management/src/app.dart';
import 'package:subscription_management/src/setup/initialize_application.dart';

@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _logoAssetPath = 'assets/images/subscription_management_logo.png';
  static const _logoEntryOffset = 80.0;

  late AnimationController _controller;
  late Animation<double> _animation;
  UserAuthenticationCubit? _checkAuthentication;

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

    _controller.forward(from: 0);

    _bootstrap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(_logoAssetPath), context);
  }

  Future<void> _bootstrap() async {
    await initializeApplication();
    if (!mounted) {
      return;
    }

    setState(() {
      _checkAuthentication = GetIt.I.get<UserAuthenticationCubit>();
    });

    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) {
      return;
    }

    await _controller.forward();
    _checkAuthentication?.checkAuthentication();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToSelectLoginMethodPage() {
    context.pushRoute(SelectLoginMethodRoute());
  }

  void _navigateToHomePage() {
    context.pushRoute(const HomePageRoute());
  }

  Widget _buildSplashBody() {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _logoEntryOffset * (1 - _animation.value)),
            child: child,
          );
        },
        child: Image.asset(
          _logoAssetPath,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final splashBody = _buildSplashBody();
    final cubit = _checkAuthentication;

    if (cubit == null) {
      return Scaffold(
        backgroundColor: App.splashBackgroundColor,
        body: splashBody,
      );
    }

    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        backgroundColor: App.splashBackgroundColor,
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
          child: splashBody,
        ),
      ),
    );
  }
}
