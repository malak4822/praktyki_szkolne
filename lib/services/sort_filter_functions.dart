import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prakty/models/advertisements_model.dart';
import 'package:prakty/models/user_model.dart';
import 'package:prakty/services/gmapfetchingurl.dart';

class SortFunctions {
  const SortFunctions(this.info, this.correctSearchinPrefs);
  final List info;
  final List<int> correctSearchinPrefs;

  Future<List<dynamic>?> sortParticularAlgorytm(
      bool isUserNoticePage, String? currentUserPlaceId) async {
    late int radioSortValue;
    late int radioFilter;
    if (isUserNoticePage) {
      radioSortValue = correctSearchinPrefs[0];
      radioFilter = correctSearchinPrefs[1];
    } else {
      radioSortValue = correctSearchinPrefs[2];
      radioFilter = correctSearchinPrefs[3];
    }
    List<dynamic>? noticesInfo = List.from(info);

    //  FILTERING
    if (isUserNoticePage == false) {
      noticesInfo.cast<JobAdModel>().toList();
      switch (radioFilter) {
        case 0:
          break;
        case 1:
          noticesInfo =
              List.from(noticesInfo.where((notice) => notice.canRemotely));
          break;
        case 2:
          noticesInfo =
              List.from(noticesInfo.where((notice) => notice.arePaid));
          break;
      }
    }
    if (isUserNoticePage) {
      noticesInfo.cast<MyUser>().toList();
      switch (radioSortValue) {
        case 0:
          Map<String, int>? places =
              await countDistanceToSort(false, currentUserPlaceId!);
          if (places != null) {
            noticesInfo.sort((a, b) => (places[a.userId] ?? double.infinity)
                .compareTo(places[b.userId] ?? double.infinity));
          }
          break;

        case 1:
          noticesInfo
              .sort((a, b) => b.accountCreated.compareTo(a.accountCreated));

          break;
        case 2:
          noticesInfo
              .sort((a, b) => b.skillsSet.length.compareTo(a.skillsSet.length));

          break;
        case 3:
          noticesInfo.sort((a, b) {
            if (a.age == null || b.age == null) {
              return 0;
            } else {
              return b.age!.compareTo(a.age!);
            }
          });
          break;
      }
    } else {
      // noticesInfo as List<JobAdModel>;
      noticesInfo.cast<JobAdModel>().toList();

      switch (radioSortValue) {
        case 0:
          Map<String, int>? places =
              await countDistanceToSort(true, currentUserPlaceId!);

          if (places != null) {
            noticesInfo.sort((a, b) => (places[a.jobId] ?? double.infinity)
                .compareTo(places[b.jobId] ?? double.infinity));
          }

          break;
        case 1:
          noticesInfo.sort((a, b) {
            if (a.companyName.isEmpty || b.companyName.isEmpty) {
              return 0;
            } else {
              return b.companyName.compareTo(a.companyName);
            }
          });
          break;
        case 2:
          noticesInfo.sort((a, b) {
            // if (a.jobDescription.isEmpty || b.jobDescription.isEmpty) {
            //   return 99999;
            // } else {
            return b.jobDescription.length.compareTo(a.jobDescription.length);
            // }
          });
      }
    }

    return noticesInfo;
  }

  Future<Map<String, int>?> countDistanceToSort(
      bool isJobAdModel, String currentUserPlaceId) async {
    List userLocationsList = [];
    LatLng? myLatLang;

    Map<String, double> distances = {};
    Map<String, Uri> uris = {};
    Map<String, LatLng> usersLatLng = {};

    for (int i = 0; i < info.length; i++) {
      userLocationsList
          .add(isJobAdModel ? info[i].jobPlaceId : info[i].placeId);
      if (userLocationsList[i] != null || userLocationsList[i] == '') {
        String ids = isJobAdModel ? info[i].jobId : info[i].userId;
        Uri placeUri =
            takeUri(isJobAdModel ? info[i].jobPlaceId : info[i].placeId);
        uris[ids] = placeUri;
      }
    }
// TODO: naprawic opis i sortowanie inne
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
    myLatLang = await getLatLangFromPlace(takeUri(currentUserPlaceId));

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
