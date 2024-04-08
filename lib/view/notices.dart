import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/pages/jobs/addeditjob.dart';
import 'package:prakty/pages/user/edituserpage.dart';
import 'package:prakty/providers/edituser.dart';
import 'package:prakty/providers/googlesign.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/services/sort_filter_functions.dart';
import 'package:prakty/widgets/noticecard.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:prakty/widgets/sortandfilter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticesPage extends StatefulWidget {
  NoticesPage(
      {super.key,
      this.isAccountTypeUser,
      required this.isUserNoticePage,
      required this.currentUserPlaceId,
      required this.wasSortedByLocation,
      required this.callBack,
      required this.usersSortedByLocation});

  List<MyUser>? usersSortedByLocation;
  final Function callBack;
  bool wasSortedByLocation;
  final bool? isAccountTypeUser;
  final bool isUserNoticePage;
  final String? currentUserPlaceId;

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  Future<List<MyUser>>? usersData;
  Future<List<JobAdModel>>? jobsData;

  List<int> correctSearchinPrefs = [0, 0, 0, 0];

  @override
  void initState() {
    readSearchingPrefs();
    usersData = MyDb().downloadUsersStates();
    jobsData = MyDb().downloadJobAds();
    super.initState();
  }

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
      appBar: AppBar(toolbarHeight: 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: widget.isAccountTypeUser == false
          ? FloatingActionButton(
              backgroundColor: gradient[1],
              foregroundColor: Colors.white,
              splashColor: gradient[0],
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddEditJob(
                          initialEditingVal: null, isEditing: false))),
              child: const Icon(Icons.add))
          : null,
      body: Stack(children: [
        SafeArea(
          child: Stack(
            children: [
              FutureBuilder(
                  future: (widget.isUserNoticePage ? usersData : jobsData)
                      ?.then((value) {
                    if (widget.isUserNoticePage &&
                        correctSearchinPrefs[0] == 3 &&
                        widget.wasSortedByLocation) {
                      if (widget.currentUserPlaceId == null ||
                          widget.currentUserPlaceId!.isEmpty) {
                        // RENEWED USERS SORTED BY LOCATION;
                        print('renreww');

                        print(widget.currentUserPlaceId.runtimeType);
                        print(widget.currentUserPlaceId);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          padding: const EdgeInsets.fromLTRB(46, 4, 0, 4),
                          backgroundColor: gradient[1].withOpacity(0.86),
                          showCloseIcon: true,
                          content: Text(
                            'Sortowanie Nie Udane, Wpierw Dodaj Swoją Lokalizację',
                            style: fontSize16,
                            textAlign: TextAlign.center,
                          ),
                          duration: const Duration(seconds: 2),
                        ));
                        return usersData;
                      } else {
                        print('ESA');

                        return SortFunctions(value).sortParticularAlgorytm(
                            widget.isUserNoticePage,
                            correctSearchinPrefs[0],
                            widget.currentUserPlaceId);
                      }
                    } else {
                      // NORMAL SORTING
                      return SortFunctions(value).sortParticularAlgorytm(
                          widget.isUserNoticePage,
                          correctSearchinPrefs[0],
                          widget.currentUserPlaceId);
                    }
                    // sporo bugow z tym odswierzaniem po zmianei swojej lokalizavji
                  }),
                  // Future<List<MyUser>>?
                  builder: (BuildContext context,
                      AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingWidget();
                    } else if (snapshot.hasError || snapshot.data == null) {
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
                      if (widget.isUserNoticePage &&
                          correctSearchinPrefs[0] == 3 &&
                          widget.wasSortedByLocation == false &&
                          info.isNotEmpty) {
                        // SAVING SORTED BY LOCATION DATA
                        widget.callBack(info);
                      }

                      return CustomScrollView(
                        clipBehavior: Clip.none,
                        slivers: <Widget>[
                          SliverAppBar(
                            floating: true,
                            snap: true,
                            elevation: 10,
                            backgroundColor: Colors.transparent,
                            toolbarHeight: 80,
                            actions: [
                              const SizedBox(width: 12),
                              Expanded(
                                  child: twoButton('Sortuj', Icons.sort, 0)),
                              Expanded(
                                  child: twoButton(
                                      'Filtruj', Icons.filter_alt, 1)),
                              const SizedBox(width: 12),
                            ],
                          ),

                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            childCount: info.length,
                            (BuildContext context, int index) {
                              if (widget.isUserNoticePage) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Column(
                                      children: [
                                        NoticeCard(
                                            info: info[index] as MyUser,
                                            noticeType: 'userNotice'),
                                        const SizedBox(height: 8),
                                      ],
                                    ));
                              } else {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Column(
                                      children: [
                                        NoticeCard(
                                            info: info[index] as JobAdModel,
                                            noticeType: 'jobNotice'),
                                        const SizedBox(height: 8),
                                      ],
                                    ));
                              }
                            },
                          )),
                          // ),
                        ],
                      );
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
                              builder: (context, searchPrefs, child) =>
                                  ListView(
                                shrinkWrap: true,
                                children: WidgetListGenerator(
                                    listToOpen, tempSearchingPrefs.value,
                                    (int newValue) {
                                  List<int> temporarySearchingPrefs =
                                      List.from(tempSearchingPrefs.value);

                                  temporarySearchingPrefs[listToOpen] =
                                      newValue;

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
                                    if (tempSearchingPrefs.value[0] == 3 &&
                                        Provider.of<GoogleSignInProvider>(
                                                    context,
                                                    listen: false)
                                                .getCurrentUser
                                                .placeId ==
                                            null) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                backgroundColor: gradient[1],
                                                elevation: 8,
                                                iconColor: Colors.white,
                                                icon: const Icon(
                                                    Icons.location_pin,
                                                    size: 32),
                                                titleTextStyle: fontSize20,
                                                contentTextStyle: fontSize16,
                                                title: const Text(
                                                    "Brak Lokalizacji"),
                                                content: const Text(
                                                  "Aby Sortować Po Lokalizacji Najpierw Musisz Dodać Swoją",
                                                  textAlign: TextAlign.center,
                                                ),
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                actions: [
                                                  ElevatedButton.icon(
                                                      onPressed: () {
                                                        isTabVisible.value =
                                                            false;
                                                        Provider.of<EditUser>(
                                                                context,
                                                                listen: false)
                                                            .toogleEditingPopUp(
                                                                1);
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const EditUserPage()));
                                                      },
                                                      icon: const Icon(
                                                          Icons.arrow_right_alt,
                                                          color: Colors.white),
                                                      label: Text(
                                                          'Ustaw Lokalizację',
                                                          style: fontSize16))
                                                ],
                                              ));
                                    } else {
                                      correctSearchinPrefs =
                                          tempSearchingPrefs.value;
                                      setSearchingPrefs();
                                      isTabVisible.value = false;
                                      setState(() {});
                                    }
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
      ]),
    );
  }

  Widget twoButton(String txt, IconData icon, int num) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(width: 2, color: Colors.white),
          elevation: 3,
          padding: const EdgeInsets.symmetric(vertical: 16),
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

// TODO NIE DZIALA ZE NIE MASZ LOKALIZACJI TO SOERTUJE PO LOKAZLIZACJI I TAK
