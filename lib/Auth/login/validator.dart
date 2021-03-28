import 'dart:async';

mixin Validator {
  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("a")) {
      sink.add(email);
    } else {
      sink.addError("Email is invalid");
    }
  });
  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4) {
      sink.add(password);
    } else {
      sink.addError("Password length should be greater then 4 chars.");
    }
  });
}
