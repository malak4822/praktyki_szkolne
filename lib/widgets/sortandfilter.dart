import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';

// class SortUsers  {

//   @override
//   List<Widget> lis =>Container();
// }
class WidgetListGenerator {
  WidgetListGenerator(this.listToOpen, this.searchingPrefs, this.callBack);

  String listToOpen;
  Function callBack;
  List<int> searchingPrefs;

  Widget myText(index, text, sortPageNumber) => ListTile(
      title: Text(text, style: fontSize16),
      leading: Radio(
        fillColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(Colors.white),
        value: index,
        groupValue: searchingPrefs[sortPageNumber],
        onChanged: (value) {
          callBack(sortPageNumber, value);
        },
      ));

  List<Widget> getMappedList(List<String> function, int sortPageNumber) {
    return function
        .asMap()
        .entries
        .map((entry) => myText(entry.key, entry.value, sortPageNumber))
        .toList();
  }

  List<Widget> generateWidgetList() {
    if (listToOpen == 'sortUsers') {
      return getMappedList(sortUsers(), 0);
    } else if (listToOpen == 'filterUsers') {
      return getMappedList(filterUsers(), 1);
    } else if (listToOpen == 'sortJobs') {
      return getMappedList(sortJobs(), 2);
    } else if (listToOpen == 'filterJobs') {
      return getMappedList(filterJobs(), 3);
    } else {
      return [];
    }
  }
}

List<String> sortUsers() {
  return [
    'Od Najstarszych Wiekiem',
    'Od Największej Ilości Umiejętności',
    'Od Najbliżej Położonych'
  ];
}

List<String> filterUsers() {
  return ['filterUser1', 'filterUser2', 'filterUser3'];
}

List<String> sortJobs() {
  return ['sortJobs1', 'sortJobs2', 'sortJobs3'];
}

List<String> filterJobs() {
  return ['filterJobs1', 'filterJobs2', 'filterJobs3'];
}
