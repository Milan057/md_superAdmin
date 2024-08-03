import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:md_customer/add_new_bus_admin/cubit/add_new_bus_admin_cubit.dart';
import 'package:md_customer/dashboard/views/dashboard.dart';
import 'package:md_customer/helper/elevatedButton.dart';
import 'package:md_customer/helper/textField.dart';
import 'package:md_customer/login/cubit/login_cubit.dart';
import 'package:md_customer/login/views/login.dart';

import '../../helper/colors.dart';

class AddNewBusAdmin extends StatelessWidget {
  const AddNewBusAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController shortNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController contactController = TextEditingController();
    AddNewBusAdminCubit bloc = BlocProvider.of<AddNewBusAdminCubit>(context);
    return Scaffold(
      backgroundColor: Color(0XFF12131F),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: BlocListener<AddNewBusAdminCubit, AddNewBusAdminState>(
              listenWhen: (previous, current) =>
                  current is AddNewBusAdminActionState,
              listener: (context, state) {
                if (state is NewBusAdminSucessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("New Bus Admin Added!")));
                  Navigator.of(context).pop();
                } else if (state is NewBusAdminError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is NewBusAdminForbidden) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "Add A New Bus Admin",
                        style: TextStyle(
                            fontSize: 30,
                            color: textWhiteColor,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // ----------- Operator Full Name -----------------
                      BlocBuilder<AddNewBusAdminCubit, AddNewBusAdminState>(
                        buildWhen: (previous, current) =>
                            current is NewBusAdminFullNameError,
                        builder: (context, state) {
                          if (state is NewBusAdminFullNameError &&
                              state.errorMessage != null) {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: fullNameController,
                                hintText: "Company Full Name",
                                icon: Icons.directions_bus_rounded,
                                errorText: state.errorMessage,
                                type: TextInputType.text);
                          } else {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: fullNameController,
                                hintText: "Company Full Name",
                                icon: Icons.directions_bus_rounded,
                                errorText: null,
                                type: TextInputType.text);
                          }
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // ----------- Operator Short Name -----------------
                      BlocBuilder<AddNewBusAdminCubit, AddNewBusAdminState>(
                        buildWhen: (previous, current) =>
                            current is NewBusAdminShortNameError,
                        builder: (context, state) {
                          if (state is NewBusAdminShortNameError &&
                              state.errorMessage != null) {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: shortNameController,
                                hintText: "Company Short Name",
                                icon: Icons.tag_rounded,
                                errorText: state.errorMessage,
                                type: TextInputType.text);
                          } else {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: shortNameController,
                                hintText: "Company Short Name",
                                icon: Icons.tag_rounded,
                                errorText: null,
                                type: TextInputType.text);
                          }
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // ----------- Operator Email -----------------

                      BlocBuilder<AddNewBusAdminCubit, AddNewBusAdminState>(
                        buildWhen: (previous, current) =>
                            current is NewBusAdminEmailError,
                        builder: (context, state) {
                          if (state is NewBusAdminEmailError &&
                              state.errorMessage != null) {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: emailController,
                                hintText: "Email Address",
                                icon: Icons.email,
                                errorText: state.errorMessage,
                                type: TextInputType.emailAddress);
                          } else {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: emailController,
                                hintText: "Email Address",
                                icon: Icons.email,
                                errorText: null,
                                type: TextInputType.emailAddress);
                          }
                        },
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      // ----------- Operator Contact -----------------

                      BlocBuilder<AddNewBusAdminCubit, AddNewBusAdminState>(
                        buildWhen: (previous, current) =>
                            current is NewBusAdminPhoneError,
                        builder: (context, state) {
                          if (state is NewBusAdminPhoneError &&
                              state.errorMessage != null) {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: contactController,
                                hintText: "Contact",
                                icon: Icons.phone,
                                errorText: state.errorMessage,
                                type: TextInputType.number);
                          } else {
                            return getInputFormInputText(
                                inputFormatter: getAllCharFormatter(),
                                controller: contactController,
                                hintText: "Contact",
                                icon: Icons.phone,
                                errorText: null,
                                type: TextInputType.number);
                          }
                        },
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      BlocBuilder<AddNewBusAdminCubit, AddNewBusAdminState>(
                        builder: (context, state) {
                          state = state;
                          if (state is NewBusAdminLoadingState) {
                            return getBlueElevatedButton(
                                text: "Add",
                                onClick: () {
                                  bloc.addOperatorButtonClicked(
                                      fullNameController.text,
                                      shortNameController.text,
                                      emailController.text,
                                      contactController.text);
                                },
                                isLoading: true);
                          } else {
                            return getBlueElevatedButton(
                                text: "Add",
                                onClick: () {
                                  bloc.addOperatorButtonClicked(
                                      fullNameController.text,
                                      shortNameController.text,
                                      emailController.text,
                                      contactController.text);
                                });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
      )),
    );
  }
}
