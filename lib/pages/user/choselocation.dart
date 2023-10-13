import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/services/gmapfetchingurl.dart';

class FindOnMap extends StatefulWidget {
  const FindOnMap({super.key});

  @override
  State<FindOnMap> createState() => _FindOnMapState();
}

class _FindOnMapState extends State<FindOnMap> {
  TextEditingController locationController = TextEditingController();
  List<AutoCompletePrediction> placePredictions = [];

  @override
  Widget build(BuildContext context) {
    void placeAutoComplete(String query) async {
      Uri uri =
          Uri.https('maps.googleapis.com', 'maps/api/place/autocomplete/json', {
        "input": query,
        "key": 'AIzaSyD-iZk4gYYy7TO8qGW7e-SgBoXzTvg6-Wo',
      });
      String? response = await NetworkUtility().fetchUrl(uri);
      if (response != null) {
        PlaceAutoCompleteResponse result =
            PlaceAutoCompleteResponse.parseAutocompleteResult(response);
        if (result.predictions != null) {
          setState(() {
            placePredictions = result.predictions!;
          });
        }
      }
    }

    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  boxShadow: myOutlineBoxShadow,
                  borderRadius: BorderRadius.circular(16)),
              child: TextFormField(
                  onChanged: (val) {
                    placeAutoComplete(val);
                  },
                  textAlign: TextAlign.center,
                  cursorColor: Colors.white,
                  style: fontSize16,
                  controller: locationController,
                  decoration: InputDecoration(
                    iconColor: Colors.white,
                    contentPadding: const EdgeInsets.all(2),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 4, color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    hintStyle: fontSize16,
                    hintText: 'Wpisz Miejsce',
                  ))),
          const SizedBox(height: 8),
          Expanded(
              child: ListView.builder(
            itemCount: placePredictions.length,
            itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    boxShadow: myOutlineBoxShadow,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white12),
                child: Center(
                    child: Text(placePredictions[index].description ?? 'brak',
                        style: fontSize16, overflow: TextOverflow.fade))),
          )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.white24,
                  elevation: 20),
              onPressed: () async {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(Icons.my_location_sharp),
                  Text(' Użyj Mojej Lokalizacji', style: fontSize16)
                ],
              )),
        ]),
      ),
      Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 49, 182, 209),
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(50))),
          child: IconButton(
              alignment: Alignment.topLeft,
              iconSize: 28,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white)))
    ])));
  }
}
