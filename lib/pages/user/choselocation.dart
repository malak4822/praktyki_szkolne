import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prakty/constants.dart';
import 'package:prakty/services/gmapfetchingurl.dart';
import 'package:prakty/widgets/backbutton.dart';

class FindOnMap extends StatefulWidget {
  const FindOnMap({super.key, required this.callBack});

  @override
  State<FindOnMap> createState() => _FindOnMapState();
  final Function callBack;
}

class _FindOnMapState extends State<FindOnMap> {
  TextEditingController locationController = TextEditingController();
  List<AutoCompletePrediction> placePredictions = [];

  List<Placemark> placesFromLocation = [];

  void placeAutoCompleteFromLocation(Placemark querys) async {
    placePredictions = [];
    for (int i = 0; 6 > i; ++i) {
      String query = '';
      switch (i) {
        case 0:
          query = querys.administrativeArea!;
          break;
        case 1:
          query = querys.locality!;
          break;
        case 2:
          query = querys.subAdministrativeArea!;
          break;
        case 3:
          query = querys.subLocality!;
          break;
        case 4:
          query = querys.thoroughfare!;
          break;
        case 5:
          query = querys.street!;
          break;
      }

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
          placePredictions.add(result.predictions![0]);
        }
      }
    }
    List<AutoCompletePrediction> uniquePlacePredictions = [];
    for (var prediction in placePredictions) {
      if (!uniquePlacePredictions
          .any((element) => element.description == prediction.description)) {
        uniquePlacePredictions.add(prediction);
      }
    }

    placePredictions = List.from(uniquePlacePredictions);

    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: myBoxShadow,
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
                            foregroundColor: Colors.white,
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
                            const FaIcon(
                              Icons.my_location_sharp,
                              color: Colors.white,
                            ),
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
                  Row(
                    children: [
                      Expanded(
                          child: Container(
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
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.done, color: Colors.white),
                              color: Colors.white,
                              onPressed: () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              },
                            ),
                            iconColor: Colors.white,
                            contentPadding: const EdgeInsets.all(2),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 4, color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            hintStyle: fontSize16,
                            hintText: 'Wybierz Lokalizacje',
                          ),
                        ),
                      )),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: myBoxShadow,
                          color: const Color.fromARGB(255, 0, 117, 190),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.location_searching_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await findMe();
                            placeAutoCompleteFromLocation(
                                placesFromLocation[0]);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            backButton(context),
          ],
        ),
      ),
    );
  }

  Future<void> findMe() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // User denied permission. Handle appropriately.
        return;
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    placesFromLocation = placemarks;
  }
}
