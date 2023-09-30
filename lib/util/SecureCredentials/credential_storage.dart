abstract class CredentialsStorage {
  Future<String?> read();
  Future<void> save(String token);
  Future<void> clear();
}
