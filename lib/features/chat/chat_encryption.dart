import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final _key = Key.fromUtf8('1234567890123456'); // 16 chars key
  static final _iv = IV.fromUtf8('abcdefghijklmnop');   // 16 chars IV

  static String encryptText(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: _iv);
    return decrypted;
  }
}