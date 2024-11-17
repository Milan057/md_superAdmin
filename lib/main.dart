import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:md_customer/add_new_bus_admin/cubit/add_new_bus_admin_cubit.dart';
import 'package:md_customer/add_new_bus_admin/repository/add_new_bus_repository.dart';
import 'package:md_customer/add_new_bus_admin/views/add_new_bus_admin.dart';
import 'package:md_customer/dashboard/cubit/dashboard_cubit.dart';
import 'package:md_customer/dashboard/repository/dashboard_repo.dart';
import 'package:md_customer/dashboard/views/dashboard.dart';
import 'package:md_customer/login/cubit/login_cubit.dart';
import 'package:md_customer/login/repository/login_repository.dart';
import 'package:http/http.dart' as http;
import 'package:md_customer/login/views/login.dart';

import 'http/timeoutClient.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => LoginCubit(LoginRepository())),
      BlocProvider(
          create: (context) => AddNewBusAdminCubit(AddNewBusRepository())),
      BlocProvider(create: (context) => DashboardCubit(DashboardRepo())),
    ],
    child: MaterialApp(
      home: const Login(),
      theme: ThemeData(fontFamily: "Poppins"),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
