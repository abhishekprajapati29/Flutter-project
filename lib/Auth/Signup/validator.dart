import 'dart:async';

mixin Validator {
  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
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
  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (username.length > 4) {
      sink.add(username);
    } else {
      sink.addError("Username is invalid");
    }
  });
  var passwordConfirmValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (passwordConfirm, sink) {
    if (passwordConfirm.length > 4) {
      sink.add(passwordConfirm);
    } else {
      sink.addError("Password length should be greater then 4 chars.");
    }
  });
}
