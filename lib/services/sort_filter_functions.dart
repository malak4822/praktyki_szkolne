import 'package:prakty/models/user_model.dart';

class SortFunctions {
  const SortFunctions(this.info);
  final List info;

  List sortParticularAlgorytm(radioValue) {
    List<MyUser> noticesInfo = List.from(info);
    switch (radioValue) {
      case 0:
        noticesInfo
            .sort((a, b) => b.accountCreated.compareTo(a.accountCreated));
      case 1:
        noticesInfo.sort((a, b) {
          if (a.age == null || b.age == null) {
            return 0;
          } else {
            return b.age!.compareTo(a.age!);
          }
        });
        break;
      case 2:
        noticesInfo
            .sort((a, b) => b.skillsSet.length.compareTo(a.skillsSet.length));
        break;
      case 3:
        countDistanceToSort(true);
        break;
    }
    return noticesInfo;
  }

  void countDistanceToSort(bool isJobAdModel) {
    List userLocationsList = [];
    for (var element in info) {
      userLocationsList
          .add(isJobAdModel ? element.location : element.jobLocation);
    }
    print(userLocationsList);
  }
}
