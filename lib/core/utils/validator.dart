abstract class ValidatorBase {
  String? email(String? data);

  String? name(String? data);

  String? description(String? data);

  String? lastName(String data);

  String? phone(String data, {bool required});

  String? password(String data);

  String? passwordMatch(String pass, String data);
}

class Validator extends ValidatorBase {
  @override
  String? email(String? data) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);

    if (data!.isEmpty) {
      return 'Cannot be empty';
    } else if (!regex.hasMatch(data)) {
      return 'Invalid email format';
    } else {
      return null;
    }
  }

  @override
  String? lastName(String data) {
    if (data.isEmpty) {
      return 'Cannot be empty';
    } else if (data.length < 4) {
      return 'Last Name to short';
    } else {
      return null;
    }
  }

  @override
  String? name(String? data) {
    if (data!.isEmpty) {
      return 'Cannot be empty';
    } else if (data.length < 4) {
      return 'Name to short';
    } else {
      return null;
    }
  }

  @override
  String? password(String data) {
    if (data.isEmpty) {
      return 'Cannot be empty';
    } else if (data.length < 8) {
      return '8 to 50 characters long';
    } else if (!data.contains(new RegExp(r'[A-Z]'))) {
      return 'At least 1 uppercase letter';
    } else if (!data.contains(new RegExp(r'[a-z]'))) {
      return 'At least 1 lowercase letter';
    } else if (!data.contains(new RegExp(r'[0-9]'))) {
      return 'At least 1 numeric digit';
    } else {
      return null;
    }
  }

  @override
  String? phone(String data, {bool required = false}) {
    if (!required && data.isEmpty) return null;
    if (data.isEmpty) {
      return 'Cannot be empty';
    } else if (!data.contains(RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)'))) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }

  @override
  String? passwordMatch(String pass, String data) {
    if (pass == data) {
      return null;
    } else {
      return 'Password don`t match';
    }
  }

  @override
  String? description(String? data) {
    if (data!.isEmpty) {
      return 'Cannot be empty';
    } else if (data.length < 10) {
      return 'Description to short, 10 characters min.';
    } else {
      return null;
    }
  }
}
