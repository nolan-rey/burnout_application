class Coach {
  final int id;
  final String name;
  final String specialty;
  final String imageUrl;
  final String availability;
  final bool isAvailable;
  final bool isPro;

  const Coach({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.availability,
    this.isAvailable = false,
    this.isPro = false,
  });
}
