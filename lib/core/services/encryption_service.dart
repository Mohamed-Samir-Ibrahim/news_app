import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  // For password hashing (recommended for authentication)
  static String hashPassword(String password) {
    // Add salt for extra security (store this securely)
    final salt = 'your-secret-salt-here'; // Use a secure salt
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate a secure salt - store this in .env file
  static String generateSecureSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  // Actual encryption/decryption methods (if needed for other data)
  static Encrypted encryptAES(String plainText, String keyString) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(plainText, iv: iv);
  }

  static String decryptAES(Encrypted encrypted, String keyString) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
