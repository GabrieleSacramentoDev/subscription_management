// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [HomePage]
class HomePageRoute extends PageRouteInfo<void> {
  const HomePageRoute({List<PageRouteInfo>? children})
    : super(HomePageRoute.name, initialChildren: children);

  static const String name = 'HomePageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginPageRoute extends PageRouteInfo<LoginPageRouteArgs> {
  LoginPageRoute({
    Key? key,
    required bool isFromSignUp,
    List<PageRouteInfo>? children,
  }) : super(
         LoginPageRoute.name,
         args: LoginPageRouteArgs(key: key, isFromSignUp: isFromSignUp),
         initialChildren: children,
       );

  static const String name = 'LoginPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginPageRouteArgs>();
      return LoginPage(key: args.key, isFromSignUp: args.isFromSignUp);
    },
  );
}

class LoginPageRouteArgs {
  const LoginPageRouteArgs({this.key, required this.isFromSignUp});

  final Key? key;

  final bool isFromSignUp;

  @override
  String toString() {
    return 'LoginPageRouteArgs{key: $key, isFromSignUp: $isFromSignUp}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginPageRouteArgs) return false;
    return key == other.key && isFromSignUp == other.isFromSignUp;
  }

  @override
  int get hashCode => key.hashCode ^ isFromSignUp.hashCode;
}

/// generated route for
/// [SelectLoginMethodPage]
class SelectLoginMethodRoute extends PageRouteInfo<SelectLoginMethodRouteArgs> {
  SelectLoginMethodRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        SelectLoginMethodRoute.name,
        args: SelectLoginMethodRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'SelectLoginMethodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectLoginMethodRouteArgs>(
        orElse: () => const SelectLoginMethodRouteArgs(),
      );
      return SelectLoginMethodPage(key: args.key);
    },
  );
}

class SelectLoginMethodRouteArgs {
  const SelectLoginMethodRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'SelectLoginMethodRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SelectLoginMethodRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [SelectStreamingPage]
class SelectStreamingPageRoute extends PageRouteInfo<void> {
  const SelectStreamingPageRoute({List<PageRouteInfo>? children})
    : super(SelectStreamingPageRoute.name, initialChildren: children);

  static const String name = 'SelectStreamingPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectStreamingPage();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute({List<PageRouteInfo>? children})
    : super(SplashScreenRoute.name, initialChildren: children);

  static const String name = 'SplashScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [StreamingManagementPage]
class StreamingManagementPageRoute
    extends PageRouteInfo<StreamingManagementPageRouteArgs> {
  StreamingManagementPageRoute({
    Key? key,
    required bool newStreaming,
    required StreamingEntity streaming,
    List<PageRouteInfo>? children,
  }) : super(
         StreamingManagementPageRoute.name,
         args: StreamingManagementPageRouteArgs(
           key: key,
           newStreaming: newStreaming,
           streaming: streaming,
         ),
         initialChildren: children,
       );

  static const String name = 'StreamingManagementPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StreamingManagementPageRouteArgs>();
      return StreamingManagementPage(
        key: args.key,
        newStreaming: args.newStreaming,
        streaming: args.streaming,
      );
    },
  );
}

class StreamingManagementPageRouteArgs {
  const StreamingManagementPageRouteArgs({
    this.key,
    required this.newStreaming,
    required this.streaming,
  });

  final Key? key;

  final bool newStreaming;

  final StreamingEntity streaming;

  @override
  String toString() {
    return 'StreamingManagementPageRouteArgs{key: $key, newStreaming: $newStreaming, streaming: $streaming}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StreamingManagementPageRouteArgs) return false;
    return key == other.key &&
        newStreaming == other.newStreaming &&
        streaming == other.streaming;
  }

  @override
  int get hashCode => key.hashCode ^ newStreaming.hashCode ^ streaming.hashCode;
}
