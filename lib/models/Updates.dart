/// Model to store Updates Details
class Updates {
  final String documentURL;

  Updates({required this.documentURL});

  factory Updates.fromMap(Map<String, dynamic> map) {
    return Updates(
      documentURL: map['documentURL'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'documentURL': documentURL,
      };
}
