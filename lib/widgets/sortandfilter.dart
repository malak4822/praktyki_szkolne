import 'package:flutter/material.dart';

// class SortUsers  {

//   @override
//   List<Widget> lis =>Container();
// }
class WidgetListGenerator {
  List<Widget> generateWidgetList(String listToOpen) {
    List<String>? Function()? whichList;

    if (listToOpen == 'sortUsers') {
      whichList = sortUsers;
    } else if (listToOpen == 'filterUsers') {
      whichList = filterUsers;
    } else if (listToOpen == 'sortJobs') {
      whichList = sortJobs;
    } else if (listToOpen == 'filterJobs') {
      whichList = filterJobs;
    }

    // Use null-aware operator to check if whichList is null before calling
    return whichList?.call()?.map((text) => Text(text)).toList() ?? [];
  }
}
List<String> sortUsers() {
  return [
    'Od Najstarszych',
    'Od Największej Ilości Umiejętności'
        'Od Najbliżej Położonych'
  ];
}

List<String> filterUsers() {
  return [
    'filterUser1',
    'filterUser2'
        'filterUser3'
  ];
}

List<String> sortJobs() {
  return [
    'sortJobs1',
    'sortJobs2'
        'sortJobs3'
  ];
}

List<String> filterJobs() {
  return [
    'filterJobs1',
    'filterJobs2'
        'filterJobs3'
  ];
}
