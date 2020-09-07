class CityModel {
  final List places;
  final int id;
  final String title;

  CityModel({this.places, this.id, this.title});

  factory CityModel.fromJson(Map<String, dynamic> json) {

    print("Response2" + json.toString());
    return CityModel(
      places: json['result']['places'],
    );
  }
}
