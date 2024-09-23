class PortModel {
  String? name;
  String? city;
  String? country;
  String? province;
  String? timezone;
  List<dynamic>? unlocs;
  String? code;

  PortModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    city = json['city'];
    country = json['country'];
    province = json['province'];
    timezone = json['timezone'];
    unlocs = json['unlocs'];
    code = json['code'];
  }
}
