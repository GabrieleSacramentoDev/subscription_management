import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:subscription_management/src/modules/login/domain/entities/repositories/user_authentication_repository.dart';
import 'package:subscription_management/src/modules/login/domain/entities/use_cases/user_authentication_use_case.dart';
import 'package:subscription_management/src/modules/login/external/user_authentication_datasource_impl.dart';
import 'package:subscription_management/src/modules/login/infra/datasource/user_authentication_datasource.dart';
import 'package:subscription_management/src/modules/login/infra/repositories/user_authentication_repository_impl.dart';
import 'package:subscription_management/src/modules/login/infra/use_cases/user_authentication_use_case_impl.dart';
import 'package:subscription_management/src/modules/login/presentation/cubit/user_authentication_cubit.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/repositories/notifications_repository.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/repositories/streaming_repository.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/add_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/delete_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/get_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/schedule_subscription_notification_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/update_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/external/datasources/notification_datasource_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/external/datasources/streaming_datasource_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/datasources/notification_datasource.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/datasources/streaming_datasource.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/repositories/notification_repository_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/repositories/streaming_repository_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/use_cases/add_message_use_case_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/use_cases/delete_streaming_use_case_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/use_cases/get_message_use_case_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/use_cases/schedule_subscription_notification_use_case_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/use_cases/update_streaming_use_case_impl.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/cubit/streaming_management_cubit.dart';

Dio dio = Dio();

final setup = GetIt.instance;

Future<void> registerDependencies() async {
  setupDatasources();
  setupRepositories();
  setupUseCases();
  setupCubits();
  setupEntities();
}

void setupDatasources() {
  setup.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );
  setup.registerFactory<UserAuthenticationDatasource>(
    () => UserAuthenticationDatasourceImpl(),
  );
  setup.registerFactory<StreamingDataSource>(
    () => StreamingDataSourceImpl(firestore: GetIt.I.get<FirebaseFirestore>()),
  );

  setup.registerFactory<FirebaseFirestore>(() => FirebaseFirestore.instance);
  setup.registerFactory<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(
      GetIt.I.get<FlutterLocalNotificationsPlugin>(),
    ),
  );
}

void setupRepositories() {
  setup.registerFactory<UserAuthenticationRepository>(
    () => UserAuthenticationRepositoryImpl(
      datasource: GetIt.I.get<UserAuthenticationDatasource>(),
    ),
  );
  setup.registerFactory<StreamingRepository>(
    () =>
        StreamingRepositoryImpl(dataSource: GetIt.I.get<StreamingDataSource>()),
  );
  setup.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(
      dataSource: GetIt.I.get<NotificationLocalDataSource>(),
    ),
  );
}

void setupUseCases() {
  setup.registerFactory<UserAuthenticationUseCase>(
    () => UserAuthenticationUseCaseImpl(
      repository: GetIt.I.get<UserAuthenticationRepository>(),
    ),
  );
  setup.registerFactory<AddStreamingUseCase>(
    () =>
        AddStreamingUseCaseImpl(repository: GetIt.I.get<StreamingRepository>()),
  );
  setup.registerFactory<GetStreamingUseCase>(
    () =>
        GetStreamingUseCaseImpl(repository: GetIt.I.get<StreamingRepository>()),
  );
  setup.registerFactory<UpdateStreamingUseCase>(
    () => UpdateStreamingUseCaseImpl(
      repository: GetIt.I.get<StreamingRepository>(),
    ),
  );
  setup.registerFactory<DeleteStreamingUseCase>(
    () => DeleteStreamingUseCaseImpl(
      repository: GetIt.I.get<StreamingRepository>(),
    ),
  );
  setup.registerFactory<ScheduleSubscriptionNotificationUseCase>(
    () => ScheduleSubscriptionNotificationUseCaseImpl(
      repository: GetIt.I.get<NotificationRepository>(),
    ),
  );
}

void setupCubits() {
  setup.registerFactory<UserAuthenticationCubit>(
    () => UserAuthenticationCubit(
      userAuthenticationUseCase: GetIt.I.get<UserAuthenticationUseCase>(),
    ),
  );
  setup.registerFactory<StreamingManagementCubit>(
    () => StreamingManagementCubit(
      addStreamingUseCase: GetIt.I.get<AddStreamingUseCase>(),
      getStreamingUseCase: GetIt.I.get<GetStreamingUseCase>(),
      updateStreamingUseCase: GetIt.I.get<UpdateStreamingUseCase>(),
      deleteStreamingUseCase: GetIt.I.get<DeleteStreamingUseCase>(),
      scheduleSubscriptionNotificationUseCase:
          GetIt.I.get<ScheduleSubscriptionNotificationUseCase>(),
    ),
  );
}

void setupEntities() {
  // Register your entities here
}
