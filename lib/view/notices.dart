import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/noticecard.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:prakty/widgets/sortandfilter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticesPage extends StatefulWidget {
  const NoticesPage(
      {super.key, this.isAccountTypeUser, required this.isUserNoticePage});

  final bool? isAccountTypeUser;
  final bool isUserNoticePage;

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  @override
  void initState() {
    readSearchingPrefs();
    super.initState();
  }

  List<int> correctSearchinPrefs = [0, 0, 0, 0];

  ValueNotifier<List<int>> tempSearchingPrefs =
      ValueNotifier<List<int>>([0, 0, 0, 0]);
  final ValueNotifier<bool> isTabVisible = ValueNotifier<bool>(false);
  int listToOpen = 0;

  void readSearchingPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> searchingPrefStringList =
        prefs.getStringList('searchingPrefs') ?? ['0', '0', '0', '0'];

    List<int> convertedToInts =
        List.from(searchingPrefStringList.map((e) => int.parse(e)));

    correctSearchinPrefs = convertedToInts;
    tempSearchingPrefs.value = convertedToInts;
  }

  void setSearchingPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> converted =
        List.from(correctSearchinPrefs.map((e) => e.toString()));

    await prefs.setStringList('searchingPrefs', converted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: widget.isAccountTypeUser == false
          ? FloatingActionButton(
              backgroundColor: gradient[1],
              foregroundColor: Colors.white,
              splashColor: gradient[0],
              onPressed: () => Navigator.pushNamed(context, '/addJob'),
              child: const Icon(Icons.add))
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
                future: widget.isUserNoticePage
                    ? MyDb().downloadUsersStates()
                    : MyDb().downloadJobAds(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Object>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_searching_outlined,
                                    color: gradient[0], size: 52),
                                const SizedBox(height: 30),
                                Text('Narazie Niestety Nie Ma Ogłoszeń',
                                    style: GoogleFonts.overpass(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: gradient[0]),
                                    textAlign: TextAlign.center)
                              ])),
                    );
                  } else {
                    List<dynamic> info = snapshot.data!;

                    // void countDistanceToSort() {
                    //   List userLocationsList = [];
                    //   for (var element in noticesList) {
                    //     userLocationsList.add(element['location']);
                    //   }
                    //   print(userLocationsList);
                    // }

                    // void sortParticularAlgorytm(radioValue) {
                    //   switch (radioValue) {
                    //     case 0:
                    //       noticesList.sort((a, b) => b['accountCreated']
                    //           .compareTo(a['accountCreated']));
                    //       break;
                    //     case 1:
                    //       noticesList
                    //           .sort((a, b) => b['age'].compareTo(a['age']));
                    //       break;
                    //     case 2:
                    //       noticesList.sort((a, b) => b['skillsSet']
                    //           .length
                    //           .compareTo(a['skillsSet'].length));
                    //       break;
                    //     case 3:
                    //       // countDistanceToSort();
                    //       break;
                    //   }
                    // }

                    switch (widget.isUserNoticePage) {
                      case true:
                        // sortParticularAlgorytm(correctSearchinPrefs[0]);
                        // sortParticularAlgorytm(correctSearchinPrefs[1]);
                        break;
                      case false:
                        // sortParticularAlgorytm(correctSearchinPrefs[2]);
                        // sortParticularAlgorytm(correctSearchinPrefs[3]);
                        break;
                    }

                    return Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: twoButton('Sortuj', Icons.sort, 0)),
                                Expanded(
                                    child: twoButton(
                                        'Filtruj', Icons.filter_alt, 1)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // JOB LIST
                            Expanded(
                                child: ListView.builder(
                                    clipBehavior: Clip.none,
                                    itemCount: info.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (widget.isUserNoticePage) {
                                        return NoticeCard(
                                            info: info[index],
                                            isUserNoticePage: true);
                                      } else {
                                        return NoticeCard(
                                            info: info[index],
                                            isUserNoticePage: false);
                                      }
                                    }))
                          ],
                        ));
                  }
                }),
            ValueListenableBuilder(
              valueListenable: isTabVisible,
              builder: (context, isVisible, child) => Visibility(
                visible: isTabVisible.value,
                child: Stack(
                  children: [
                    Material(
                      color: Colors.white70,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          isTabVisible.value = false;
                        },
                        splashFactory: InkRipple.splashFactory,
                        splashColor: gradient[1],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(colors: gradient)),
                        child: Column(children: [
                          Center(
                              child: ValueListenableBuilder(
                            valueListenable: tempSearchingPrefs,
                            builder: (context, searchPrefs, child) => ListView(
                              shrinkWrap: true,
                              children: WidgetListGenerator(
                                  listToOpen, tempSearchingPrefs.value,
                                  (int newValue) {
                                List<int> temporarySearchingPrefs =
                                    List.from(tempSearchingPrefs.value);
                                temporarySearchingPrefs[listToOpen] = newValue;
                                tempSearchingPrefs.value =
                                    temporarySearchingPrefs;
                              }).generateWidgetList(),
                            ),
                          )),
                          const Spacer(),
                          SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(16))),
                                    padding: const EdgeInsets.all(12)),
                                child: const Icon(Icons.done_outline_rounded,
                                    size: 32, color: Colors.white),
                                onPressed: () async {
                                  correctSearchinPrefs =
                                      tempSearchingPrefs.value;
                                  setSearchingPrefs();
                                  setState(() {});

                                  isTabVisible.value = false;
                                },
                              ))
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget twoButton(String txt, IconData icon, int num) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 7,
          padding: const EdgeInsets.all(12),
          backgroundColor: gradient[num],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
              left: num == 0
                  ? const Radius.circular(10)
                  : const Radius.circular(0),
              right: num == 0
                  ? const Radius.circular(0)
                  : const Radius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          tempSearchingPrefs.value = List.from(correctSearchinPrefs);
          listToOpen = (widget.isUserNoticePage)
              ? (num == 0 ? 0 : 1)
              : (num == 1 ? 3 : 2);
          isTabVisible.value = true;
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(txt, style: fontSize16), Icon(icon)]),
      );
}
