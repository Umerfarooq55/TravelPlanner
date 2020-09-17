class CityDetail {
  final List places;
  final int id;
  final String image;
  final String shortDes;

  CityDetail({this.places, this.id, this.image,this.shortDes});

  factory CityDetail.fromJson(Map<String, dynamic> json) {
    return CityDetail(
      image: json['image'],
      shortDes: json['description'],
    );
  }
}
