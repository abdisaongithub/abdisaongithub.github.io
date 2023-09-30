import 'package:validators/validators.dart';

class Validators {
  static String? checkPhoneNumber(String? value) {
    if (isNull(value)) {
      return 'Phone number can\'t be empty';
    } else if (!isNumeric(value!)) {
      return 'Phone number must only be numbers';
    } else if (!isInt(value)) {
      return 'Phone number must start with 9';
    } else if (!isLength(value, 9)) {
      return 'Phone number can\'t be less than 9 digits ';
    } else if (!isLength(value, 9, 9)) {
      return 'Phone number can\'t be more than 9 digits';
    }
    return null;
  }

  static String? checkHeight(String? value) {
    if (isNull(value)) {
      return 'Height can\'t be empty';
    } else if (!((double.parse(value!)) > 0)) {
      return 'Can\'t be below 0';
    } else if (!((double.parse(value)) < 2.99)) {
      return 'Can\'t be above 2.99';
    }
    return null;
  }

  static String? checkWeight(String? value) {
    if (isNull(value)) {
      return 'Weight can\'t be empty';
    } else if (!((double.parse(value!)) > 0)) {
      return 'Can\'t be below 0';
    } else if (!((double.parse(value)) < 199.99)) {
      return 'Can\'t be above 199.99';
    }
    return null;
  }

  static String? checkDate(String? value) {
    if (isNull(value)) {
      return 'Date can\'t be empty';
    }
    return null;
  }

  static String? checkProductName(String? value) {
    if (isNull(value)) {
      return 'Product Name can\'t be empty';
    } else if (!isLength(value!, 3, 256)) {
      return 'Product Name can\'t be less than 3 letters and more than 256 letters';
    }
    return null;
  }

  static String? checkPassword(String? value) {
    if (isNull(value)) {
      return 'Password can\'t be empty';
    } else if (!isLength(value!, 6)) {
      return 'Password can\'t be less than 6 letters';
    } else if (!isLength(value, 6, 30)) {
      return 'Password can\'t be more than 30 letters';
    }
    return null;
  }

  static String? checkConfirmPassword(String? value, String anotherValue) {
    if (isNull(value)) {
      return 'Password can\'t be empty';
    } else if (!isLength(value!, 6, 24)) {
      return 'Password can\'t be less than 6 letters and max 24 letters';
    } else if (value != anotherValue) {
      return 'Password do not  match';
    }
    return null;
  }

  static String? checkPersonalName(String? value) {
    if (isNull(value)) {
      return 'Name can\'t be empty';
    } else if (!isLength(value!, 3)) {
      return 'Name can\'t be less than 3 letters';
    }
    return null;
  }

  static String? checkEmail(String? value) {
    if (isNull(value)) {
      return 'Email can\'t be empty';
    } else if (!isEmail(value!)) {
      return 'You must provide a valid Email address';
    }
    return null;
  }

  static String? checkPrice(String? value) {
    if (isNull(value)) {
      return 'Price can\'t be empty';
    } else if (!isNumeric(value!)) {
      return 'You must provide a valid number';
    } else if (num.parse(value).toDouble() <= 0.0) {
      return 'Price can\'t be a negative number';
    }
    return null;
  }
}
