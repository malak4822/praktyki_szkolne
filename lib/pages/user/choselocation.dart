import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/services/gmapfetchingurl.dart';

class FindOnMap extends StatefulWidget {
  const FindOnMap({Key? key, required this.callBack}) : super(key: key);

  @override
  State<FindOnMap> createState() => _FindOnMapState();
  final Function callBack;
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
        "key": "AIzaSyD-iZk4gYYy7TO8qGW7e-SgBoXzTvg6-Wo",
        "components": "country:PL",
        "language": "pl"
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
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor: Colors.white24),
                        onPressed: () {
                          widget.callBack(placePredictions[index].description);

                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(Icons.my_location_sharp),
                            Expanded(
                              child: Text(
                                " ${placePredictions[index].description}",
                                style: fontSize16,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 12),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: myOutlineBoxShadow,
                      borderRadius: BorderRadius.circular(16),
                    ),
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
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        hintStyle: fontSize16,
                        hintText: 'Wybierz Lokalizacje',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 49, 182, 209),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(50)),
              ),
              child: IconButton(
                alignment: Alignment.topLeft,
                iconSize: 28,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
