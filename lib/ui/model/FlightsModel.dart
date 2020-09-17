class FlightsModel {
  final List places;
  final int id;
  final String title;
  final List Go;

  FlightsModel({this.places, this.id, this.title,this.Go});

  factory FlightsModel.fromJson(Map<String, dynamic> json) {

    print("Response2" + json.toString());
    return FlightsModel(
      places: json['result'],

    );
  }
}
