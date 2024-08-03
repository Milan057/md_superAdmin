import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitialState());

  void addNewOperatorClicked() {
    emit(DashboardAddNewBusAdmin());
  }

  void logoutClicked() async {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    secureStorage.delete(key: "token");
    emit(LogoutClicked());
  }
}

abstract class DashboardState {}

abstract class DashboardActionState extends DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardAddNewBusAdmin extends DashboardActionState {}

class LogoutClicked extends DashboardActionState {}
