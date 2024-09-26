class Utils {
  static String generateImageUrl(String email) {
    String firstLetter = email.isNotEmpty
        ? email[0].toUpperCase()
        : 'U'; // Default to 'U' if email is empty
    return 'https://ui-avatars.com/api/?name=$firstLetter&background=random&color=fff&size=150';
  }

  static String generateRandomName(String uid) {
    // Use the first 9 characters of the UID and convert to letters
    String base = uid.replaceAll(
        RegExp(r'[^A-Za-z0-9]'), ''); // Remove non-alphanumeric characters
    if (base.length < 9) {
      base = base.padRight(9, 'x'); // Pad with 'x' if less than 9
    }
    String name = base.substring(0, 9); // Take the first 9 characters

    // Convert to a more name-like format
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}