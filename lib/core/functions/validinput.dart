import 'package:get/get.dart';

String? validInput(String val, int min, int max, String type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "not_valid_username".tr;
    }
  } else if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "not_valid_email".tr;
    }
  } else if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val) || val.length < 10 || val[0] != "0" || !(val[1] == "5" || val[1] == "6" || val[1] == "7")) {
      return "not_valid_phone".tr;
    }
  }

  if (val.isEmpty) {
    return "cant_be_empty".tr;
  }

  if (val.length < min) {
    return "${"cant_be_less_than".tr} $min";
  }

  if (val.length > max) {
    return "${"cant_be_larger_than".tr} $max";
  } else {
    return null;
  }
}

String? validpassword(String val, int min, int max) {
  if (val.isEmpty) {
    return "cant_be_empty".tr;
  }

  if (val.length < min) {
    return "${"cant_be_less_than".tr} $min";
  }

  if (val.length > max) {
    return "${"cant_be_larger_than".tr} $max";
  }
  return null;
}
