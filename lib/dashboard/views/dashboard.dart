import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:md_customer/add_new_bus_admin/views/add_new_bus_admin.dart';
import 'package:md_customer/dashboard/cubit/dashboard_cubit.dart';
import 'package:md_customer/helper/colors.dart';
import 'package:md_customer/helper/elevatedButton.dart';
import 'package:md_customer/helper/layout.dart';
import 'package:md_customer/login/views/login.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    DashboardCubit bloc = BlocProvider.of<DashboardCubit>(context);
    return BlocListener<DashboardCubit, DashboardState>(
      listenWhen: (previous, current) => current is DashboardActionState,
      listener: (context, state) {
        if (state is DashboardAddNewBusAdmin) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddNewBusAdmin(),
          ));
        }
        if (state is LogoutClicked) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
        }
      },
       child: RefreshIndicator(
       onRefresh: () async {
            bloc.refreshBusStatus();
          },
      child: Scaffold(
          key: _scaffoldKey,
          endDrawer: Drawer(
            backgroundColor: scaffoldColor,
            child: ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Super Admin",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: whiteColor),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: iconColorCalm,
                    child: Text(
                      "SA",
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: getBlueElevatedButton(
                      text: "Logout",
                      onClick: () {
                        bloc.logoutClicked();
                      }),
                )
              ],
            ),
          ),
          appBar: AppBar(
            toolbarHeight: 70,
            title: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Dashboard",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
            backgroundColor: scaffoldColor,
            elevation: 0.0,
            actions: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: MaterialButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: CircleAvatar(
                    backgroundColor: themeColor,
                    child: Text(
                      "SA",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Color(0XFF12131F),
          body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(1, 0, 1, 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int columns =
                          getLayoutColumns_3_2_1(constraints.maxWidth);
                      double cardWidth = constraints.maxWidth / columns;
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.zero,
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: columns,
                                      childAspectRatio:
                                          1.3, // Adjust the aspect ratio as needed
                                      mainAxisExtent: 320),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return returnMainCard(cardWidth, bloc);
                                },
                                childCount: 1, // Number of items in your grid
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )))),
    ));
  }

  Card returnMainCard(double cardWidth, DashboardCubit bloc) {
    return Card(
      color: slightScaffoldColor,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Super Admin",
              style: TextStyle(
                  color: whiteColor, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
               BlocBuilder<DashboardCubit, DashboardState>(
              buildWhen: (previous, current) => current is DashboardCountUpdateState,
              builder: (context, state) {
                return       Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: cardWidth / 4,
                    child: Card(
                      color: neutralSignColor,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Icon(Icons.list_alt_rounded),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            bloc.total,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Total Bus Admin",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    width: cardWidth / 4,
                    child: Card(
                      color: goodSignColor,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Icon(Icons.check_circle_outline),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            bloc.active,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Active Bus Admin",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    width: cardWidth / 4,
                    child: Card(
                      color: warningSignColor,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Icon(Icons.warning_rounded),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            bloc.inactive,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Inactive Bus Admin",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: getBlueElevatedButton(
                      text: "Add New Operator",
                      onClick: () {
                        bloc.addNewOperatorClicked();
                      }),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: getBlueElevatedButton(
                      text: "Manage Operators", onClick: () {}),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
