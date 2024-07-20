import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitialState());

  void addNewOperatorClicked() {
    emit(DashboardAddNewBusAdmin());
  }
}

abstract class DashboardState {}

abstract class DashboardActionState extends DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardAddNewBusAdmin extends DashboardActionState {}
