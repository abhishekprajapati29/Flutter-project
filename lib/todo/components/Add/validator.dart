import 'dart:async';

mixin Validator {
  var titleValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title.length < 25 && title.length > 0) {
      sink.add(title);
    } else {
      sink.addError("Title Length should be less then 25 chars.");
    }
  });
  var descriptionValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (description, sink) {
    if (description.length > 0) {
      sink.add(description);
    } else {
      sink.addError("Description should not be null.");
    }
  });
}
