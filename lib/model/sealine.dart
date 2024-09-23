class SealineModel {
  String? name;
  String? scac;

  SealineModel({this.name, this.scac});

  SealineModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    scac = json['scac'];
  }
}
