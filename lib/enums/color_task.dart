import 'package:taskmate_app/services/service_locator.dart';

enum ColorTask {


  red("d9534f"),
  blue("428bca"),
  orange("ff7f50"),
  yellow("ffcc5c"),
  white("ffffff"),
  ;

  final String hex;
  const ColorTask(this.hex);


}