import '../widget/container_form.dart';

class FormModel {
  String? vol;
  String? size;
  String? container;
  List<ContainerFormWidget> views = [];

  FormModel({this.vol, this.size});
}
