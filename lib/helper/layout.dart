int getLayoutColumns_3_2_1(double screenSize) {
  if (screenSize >= 1322) {
    return 3;
  } else if (screenSize >= 968) {
    return 2;
  } else {
    return 1;
  }
}
