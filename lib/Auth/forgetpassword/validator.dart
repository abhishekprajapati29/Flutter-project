import 'dart:async';

mixin Validator {
  var verifyEmailValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (verifyEmail, sink) {
    if (verifyEmail.contains("@")) {
      sink.add(verifyEmail);
    } else {
      sink.addError("Email is invalid");
    }
  });
}
