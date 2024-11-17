class DashboardModel {
  int statusCode;
  String? total;
  String? active;
  String? inactive;

  DashboardModel(
      {required this.statusCode,
      this.total,
      this.active,
      this.inactive});
  
}
