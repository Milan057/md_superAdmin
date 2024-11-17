import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../exceptions/general_exception.dart';
import '../model/DashboardModel.dart';
import '../repository/dashboard_repo.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardRepo repository;
  String total = "";
  String active = "";
  String inactive = "";
  DashboardCubit(this.repository) : super(DashboardInitialState()) {
    refreshBusStatus();
  }

  void addNewOperatorClicked() {
    emit(DashboardAddNewBusAdmin());
  }

  void logoutClicked() async {
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    secureStorage.delete(key: "token");
    emit(LogoutClicked());
  }

  refreshBusStatus() async {
    total = "-";
    active = "-";
    inactive = "-";
    try {
      DashboardModel model = await repository.fetchOperatorStatus();
      total = model.total.toString();
      active = model.active.toString();
      inactive = model.inactive.toString();
      emit(DashboardCountUpdateState());
    } on GeneralException catch (e) {
      emit(DashboardUnauthorizedException(e.message));
    } on GeneralException catch (e) {
      //Do nothing, occurs in case there is no any trip already.
    } catch (e) {
      emit(DashboardErrorMessage(
          "Client: Unable to process the response while fetching ticket Information!"));
    }
  }
}

abstract class DashboardState {}

abstract class DashboardActionState extends DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardAddNewBusAdmin extends DashboardActionState {}

class LogoutClicked extends DashboardActionState {}

class DashboardCountUpdateState extends DashboardState {}

class DashboardErrorMessage extends DashboardActionState {
  String message;
  DashboardErrorMessage(this.message);
}

class DashboardUnauthorizedException extends DashboardActionState {
  String message;
  DashboardUnauthorizedException(this.message);
}
