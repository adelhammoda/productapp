import 'dart:async';

class Validator {
  final validateEmail = StreamTransformer<String, String?>.fromHandlers(
      handleData: (String name, sink) {
    if (name.length < 4) {
      sink.addError('Your name most be more than 4 character');
    } else if (name.contains(RegExp(r'[^ a-zA-Z0-9]'))) {
      sink.addError('Your name must not  contain any symbols');
    } else {
      sink.add(name);
    }
  });
  final validatePassword = StreamTransformer<String, String?>.fromHandlers(
      handleData: (String password, sink) {
    if (password.length < 7) {
      sink.addError('Pleas enter password more than 7 character');
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      sink.addError('Password must contain at least one number');
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      sink.addError('Password must contain at least one Uppercase letter');
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      sink.addError('Password must contain at least one small letter');
    } else {
      sink.add(password);
    }
  });



}
