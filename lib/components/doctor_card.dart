import 'package:flutter/material.dart';
import '../models/doctor_model.dart';

class DoctorCard extends StatefulWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  int _selectedDateIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar box
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 14),
              // Name, category, fee
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Color(0xFFD97706), size: 12),
                          const SizedBox(width: 4),
                          Text(
                            widget.doctor.rating.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.doctor.category} · \$${widget.doctor.sessionFee.toStringAsFixed(0)}/session',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Calendar row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Availability · ${widget.doctor.availability[_selectedDateIndex].slotText}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const Text(
                'August 2026 >',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Date chips list
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.doctor.availability.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedDateIndex == index;
                final slot = widget.doctor.availability[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  child: Container(
                    width: 52,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          slot.dayName,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slot.dayNumber,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          // CTA button inside card
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: const Text(
                'View Profile & Book Session',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
