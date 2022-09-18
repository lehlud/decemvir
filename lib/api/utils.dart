import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

DateTime dateFromMillis(int millis) {
  return DateTime.fromMillisecondsSinceEpoch(millis);
}

String formatDate(DateTime date) {
  initializeDateFormatting();
  return DateFormat.yMMMd(Platform.localeName).format(date);
}

/// [data] must be of type [String] or [List<int>]
String b64Encode(dynamic data) {
  assert(data is String || data is List<int>);

  late List<int> bytes;
  if (data is String) {
    bytes = utf8.encode(data);
  } else {
    bytes = data;
  }

  return base64Encode(bytes);
}

String b64Decode(String b64) {
  return utf8.decode(base64.decode(b64));
}

String generateRandomId() {
  final millis = DateTime.now().millisecondsSinceEpoch;
  final randomInt = Random.secure().nextInt(1 << 32) - 1;
  final timeBasedRandom = ((millis << 32) + randomInt).toString();
  print(timeBasedRandom);

  final hash = sha256.convert(utf8.encode(timeBasedRandom)).toString();
  return hash;
}

// /// generates a SHA256 hash from the [key] and wraps it into a [Key]
// Key keyFromString(String key) {
//   final hash = sha256.convert(utf8.encode(key)).toString();
//   return Key.fromUtf8(hash.substring(0, 32));
// }

// Encrypter _encrypter(Key key) {
//   const encryptionMode = AESMode.sic;
//   return Encrypter(AES(key, mode: encryptionMode));
// }

// String encrypt(String data, Key key, IV iv) {
//   return _encrypter(key).encrypt(data, iv: iv).base64;
// }

// String decrypt(String data, Key key, IV iv) {
//   return _encrypter(key).decrypt(Encrypted.fromBase64(data), iv: iv);
// }
