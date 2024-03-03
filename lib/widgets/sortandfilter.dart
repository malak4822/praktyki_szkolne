import 'package:flutter/material.dart';
import 'package:prakty/constants.dart';

// class SortUsers  {

//   @override
//   List<Widget> lis =>Container();
// }
class WidgetListGenerator {
  WidgetListGenerator(this.listToOpen, this.searchingPrefs, this.callBack);

  int listToOpen;
  Function callBack;
  List<int> searchingPrefs;

  Widget myText(index, text, listToOpen) => ListTile(
      title: Text(text, style: fontSize16),
      leading: Radio(
        fillColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(Colors.white),
        value: index,
        groupValue: searchingPrefs[listToOpen],
        onChanged: (value) {
          callBack(value);
        },
      ));

  List<Widget> getMappedList(List<String> function, int listToOpen) {
    return function
        .asMap()
        .entries
        .map((entry) => myText(entry.key, entry.value, listToOpen))
        .toList();
  }

  List<Widget> generateWidgetList() {
    if (listToOpen == 0) {
      return getMappedList(sortUsers(), 0);
    } else if (listToOpen == 1) {
      return getMappedList(filterUsers(), 1);
    } else if (listToOpen == 2) {
      return getMappedList(sortJobs(), 2);
    } else if (listToOpen == 3) {
      return getMappedList(filterJobs(), 3);
    } else {
      return [];
    }
  }
}

List<String> sortUsers() => [
      'Najnowsze',
      'Najstarsi',
      'Największa Ilość Umiejętności',
      'Najbliżej Ciebię'
    ];

List<String> filterUsers() => ['filterUser1', 'filterUser2', 'filterUser3'];

List<String> sortJobs() => ['sortJobs1', 'sortJobs2', 'sortJobs3'];

List<String> filterJobs() => ['filterJobs1', 'filterJobs2', 'filterJobs3'];
