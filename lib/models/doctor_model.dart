class DoctorModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final double sessionFee;
  final List<AvailabilitySlot> availability;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.sessionFee,
    required this.availability,
  });
}

class AvailabilitySlot {
  final String dayName;
  final String dayNumber;
  final String slotText;

  const AvailabilitySlot({
    required this.dayName,
    required this.dayNumber,
    required this.slotText,
  });
}
