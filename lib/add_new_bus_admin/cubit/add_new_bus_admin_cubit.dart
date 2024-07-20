import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:md_customer/add_new_bus_admin/repository/add_new_bus_repository.dart';
import 'package:md_customer/commons/models/common_model.dart';
import 'package:md_customer/exceptions/general_exception.dart';

class AddNewBusAdminCubit extends Cubit<AddNewBusAdminState> {
  final AddNewBusRepository repository;
  AddNewBusAdminCubit(this.repository) : super(AdminNewBusAdminInitialState());

  void addOperatorButtonClicked(
      String fullName, String shortName, String email, String phone) async {
    int errorCount = 0;
    if (fullName.isEmpty) {
      errorCount++;
      emit(NewBusAdminFullNameError(errorMessage: "Full Name can't be Empty"));
    } else {
      emit(NewBusAdminFullNameError());
    }
    if (shortName.isEmpty) {
      errorCount++;
      emit(
          NewBusAdminShortNameError(errorMessage: "Short Name can't be Empty"));
    } else {
      emit(NewBusAdminShortNameError());
    }
    if (email.isEmpty) {
      errorCount++;
      emit(NewBusAdminEmailError(errorMessage: "Email can't be Empty"));
    } else if (!(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')).hasMatch(email)) {
      errorCount++;
      emit(NewBusAdminEmailError(errorMessage: "Invalid Email"));
    } else {
      emit(NewBusAdminEmailError());
    }
    if (phone.isEmpty) {
      errorCount++;
      emit(NewBusAdminPhoneError(errorMessage: "Phone can't be Empty"));
    } else if (!(RegExp(r'^(98|97)\d{8}$')).hasMatch(phone)) {
      errorCount++;
      emit(NewBusAdminPhoneError(errorMessage: "Invalid Phone"));
    } else {
      emit(NewBusAdminPhoneError());
    }

    if (errorCount == 0) {
      emit(NewBusAdminLoadingState());
      try {
        CommonModel response =
            await repository.addNewBusAdmin(fullName, shortName, email, phone);
        if (response.statusCode == 201) {
          emit(NewBusAdminSucessState());
        }
        if (response.statusCode == 409) {
          if (response.responseType == "EMILALREADYEXISTS") {
            emit(NewBusAdminEmailError(errorMessage: response.message));
          } else if (response.responseType == "PHONEALREADYEXISTS") {
            emit(NewBusAdminPhoneError(errorMessage: response.message));
          } else if (response.responseType == "FULLNAMEALREADYEXISTS") {
            emit(NewBusAdminFullNameError(errorMessage: response.message));
          } else if (response.responseType == "SHORTNAMEALREADYEXISTS") {
            emit(NewBusAdminShortNameError(errorMessage: response.message));
          }
        } else if (response.statusCode == 403) {
          emit(NewBusAdminForbidden());
        }
      } on GeneralException catch (e) {
        emit(NewBusAdminError(e.message));
      } catch (e) {
        emit(NewBusAdminError(
            "Client: Something went wrong while processing the response!"));
      }
    }
  }
}

abstract class AddNewBusAdminState {}

abstract class AddNewBusAdminActionState extends AddNewBusAdminState {}

class AdminNewBusAdminInitialState extends AddNewBusAdminState {}

class NewBusAdminFullNameError extends AddNewBusAdminState {
  final String? errorMessage;
  NewBusAdminFullNameError({this.errorMessage});
}

class NewBusAdminShortNameError extends AddNewBusAdminState {
  final String? errorMessage;
  NewBusAdminShortNameError({this.errorMessage});
}

class NewBusAdminEmailError extends AddNewBusAdminState {
  final String? errorMessage;
  NewBusAdminEmailError({this.errorMessage});
}

class NewBusAdminPhoneError extends AddNewBusAdminState {
  final String? errorMessage;
  NewBusAdminPhoneError({this.errorMessage});
}

class NewBusAdminLoadingState extends AddNewBusAdminState {}

class NewBusAdminError extends AddNewBusAdminActionState {
  final String message;
  NewBusAdminError(this.message);
}

class NewBusAdminForbidden extends AddNewBusAdminActionState {}

class NewBusAdminSucessState extends AddNewBusAdminActionState {}
