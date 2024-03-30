import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/services/gmapfetchingurl.dart';

class SortFunctions {
  const SortFunctions(this.info, this.currentUserPlaceId);
  final List info;
  final String? currentUserPlaceId;

  Future<List<MyUser>> sortParticularAlgorytm(radioValue) async {
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
        // if (callBack()) {

        // if (currentUserPlaceId != null || currentUserPlaceId != '') {
        Map<String, int>? places = await countDistanceToSort(true);
        if (places != null) {
          noticesInfo.sort((a, b) =>
              places[a.userId] ??
              double.infinity.compareTo(places[b.userId] ?? double.infinity));

          // noticesInfo.sort((a, b) => ,)
        }

        // }
        // }
        break;
    }

    return noticesInfo;
  }

  Future<Map<String, int>?> countDistanceToSort(bool isJobAdModel) async {
    List userLocationsList = [];
    LatLng? myLatLang;

    Map<String, double> distances = {};
    Map<String, Uri> uris = {};
    Map<String, LatLng> usersLatLng = {};

    for (int i = 0; i < info.length; i++) {
      userLocationsList
          .add(isJobAdModel ? info[i].placeId : info[i].jobLocation);
      if (userLocationsList[i] != null || userLocationsList[i] == '') {
        String userId = info[i].userId;
        Uri placeUri = takeUri(info[i].placeId);
        uris[userId] = placeUri;
      }
    }

    try {
      // RETREIVING USERS LAT & LNGS

      await Future.forEach(uris.entries, (MapEntry<String, Uri> entry) async {
        LatLng? singleLatLng = await getLatLangFromPlace(entry.value);
        if (singleLatLng != null) {
          usersLatLng[entry.key] = singleLatLng;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    // RETREIVING CURRENT USER LAT & LNGS
    if (currentUserPlaceId != null) {
      myLatLang = await getLatLangFromPlace(takeUri(currentUserPlaceId!));
    }

// CALUCALTING DISTANCE BEETWEEN USERS AND CURRENT USER
    if (myLatLang != null) {
      distances = usersLatLng.map((userId, singleLatLang) {
        double latLength = (myLatLang!.latitude - singleLatLang.latitude);
        double longLength = (myLatLang.longitude - singleLatLang.longitude);

        double distance =
            (sqrt(latLength * latLength) + (longLength * longLength));

        return MapEntry(userId, distance);
      });
    }

    List<MapEntry<String, double>> sortedDistances = distances.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    Map<String, int> places = {};
    for (int i = 0; i < sortedDistances.length; i++) {
      places[sortedDistances[i].key] = i + 1; // Assign ranks starting from 1
    }

    return places;
  }

  Uri takeUri(String placeId) {
    return Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {
      'place_id': placeId,
      'key': 'AIzaSyD-iZk4gYYy7TO8qGW7e-SgBoXzTvg6-Wo',
    });
  }

  Future<LatLng?> getLatLangFromPlace(Uri uri) async {
    try {
      String? placeDetailsResponse = await NetworkUtility().fetchUrl(uri);
      if (placeDetailsResponse != null) {
        var decodedResponse = jsonDecode(placeDetailsResponse);
        PlaceDetailsResponse placeDetails =
            PlaceDetailsResponse.fromJson(decodedResponse);

        double latitude = placeDetails.result.geometry.location.lat;
        double longitude = placeDetails.result.geometry.location.lng;

        return LatLng(latitude, longitude);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}

class PlaceDetailsResponse {
  final Result result;

  PlaceDetailsResponse({required this.result});

  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResponse(
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final Geometry geometry;

  Result({required this.geometry});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      geometry: Geometry.fromJson(json['geometry']),
    );
  }
}

class Geometry {
  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location']),
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
