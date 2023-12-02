import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/services/database.dart';
import 'package:prakty/widgets/noticecard.dart';
import 'package:prakty/widgets/loadingscreen.dart';
import 'package:prakty/widgets/sortandfilter.dart';

class NoticesPage extends StatefulWidget {
  NoticesPage({
    super.key,
    this.isAccountTypeUser,
    required this.pageName,
  });

  bool? isAccountTypeUser = false;
  String pageName;

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  late String listToOpen = '';
  final ValueNotifier<bool> isTabVisible = ValueNotifier<bool>(false);
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
                future: widget.pageName == 'JobNotices'
                    ? MyDb().downloadJobAds()
                    : MyDb().downloadUsersStates(),
                builder: (context, AsyncSnapshot<List> snapshot) {
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: gradient[0]),
                                    textAlign: TextAlign.center)
                              ])),
                    );
                  } else {
                    final dynamic noticesList = snapshot.data;
                    return Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        child:
                                            twoButton('Sortuj', Icons.sort, 0)),
                                    Expanded(
                                        child: twoButton(
                                            'Filtruj', Icons.filter_alt, 1)),
                                  ],
                                )),
                            const SizedBox(height: 8),
                            // JOB LIST
                            ListView.builder(
                                clipBehavior: Clip.none,
                                itemCount: noticesList!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  if (widget.pageName == 'JobNotices') {
                                    return NoticeCard(
                                      info: noticesList[index],
                                      noticeCardName: 'JobCard',
                                    );
                                  } else {
                                    return NoticeCard(
                                      info: noticesList[index],
                                      noticeCardName: 'UserCard',
                                    );
                                  }
                                })
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
                            child: ListView(
                              shrinkWrap: true,
                              children: WidgetListGenerator()
                                  .generateWidgetList(listToOpen),
                              //  listToOpen == 'sortUsers' ? const sortUsers() : ,

                              // if (listToOpen == 'filterUsers')
                              //   const FilterUser(),
                              // if (listToOpen == 'sortJobs') const SortJobs(),
                              // if (listToOpen == 'filterJobs')
                              //   const FilterJobs(),
                            ),
                          ),
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
                                child: const Icon(Icons.done,
                                    size: 32, color: Colors.white),
                                onPressed: () async {},
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

  Widget twoButton(txt, icon, num) => ElevatedButton(
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
          listToOpen = (widget.pageName == 'UsersNotices')
              ? (num == 0 ? 'sortUsers' : 'filterUsers')
              : (num == 1 ? 'filterJobs' : 'sortJobs');

          isTabVisible.value = true;
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(txt, style: fontSize16), Icon(icon)]),
      );
}
