import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:news_app/core/services/encryption_service.dart';

class SecureStorageService {
  static final storage = FlutterSecureStorage();
  static final encryptionKey =
      'your-32-char-encryption-key-here'; // Must be 32 chars for AES

  // Store encrypted password
  static Future<void> storeEncryptedPassword(
    String key,
    String password,
  ) async {
    final encrypted = EncryptionService.encryptAES(password, encryptionKey);
    await storage.write(key: key, value: encrypted.base64);
  }

  // Retrieve and decrypt password
  static Future<String?> getDecryptedPassword(String key) async {
    final encryptedBase64 = await storage.read(key: key);
    if (encryptedBase64 != null) {
      final encrypted = Encrypted.fromBase64(encryptedBase64);
      return EncryptionService.decryptAES(encrypted, encryptionKey);
    }
    return null;
  }

  // Store hashed password (safer)
  static Future<void> storeHashedPassword(String key, String password) async {
    final hashed = EncryptionService.hashPassword(password);
    await storage.write(key: key, value: hashed);
  }

  // Verify hashed password
  static Future<bool> verifyHashedPassword(String key, String password) async {
    final storedHash = await storage.read(key: key);
    final currentHash = EncryptionService.hashPassword(password);
    return storedHash == currentHash;
  }
}
