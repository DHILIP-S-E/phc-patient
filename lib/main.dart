import 'package:flutter/material.dart';

// Import Models
import 'models/doctor_model.dart';
import 'models/health_metric_model.dart';
import 'models/meal_model.dart';

// Import Custom Components
import 'components/activity_tracker_chart.dart';
import 'components/ecg_analysis_chart.dart';
import 'components/steps_circle_progress.dart';
import 'components/metric_card.dart';
import 'components/doctor_card.dart';
import 'components/suggested_meal_card.dart';
import 'components/weight_tracker_card.dart';
import 'components/strength_score_card.dart';

// Import Sub Pages
import 'custom-pages/meal_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GramCare Patient Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Professional blue
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF0D9488),
          surface: const Color(0xFFF8FAFC),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationShell(),
    );
  }
}

/* ─────────────────────────────────────────────────────────
   Navigation Shell
───────────────────────────────────────────────────────── */
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PatientDashboardPage(),
    const HealthTrackingPage(),
    const DoctorConsultationPage(),
    const ProfileSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF2563EB),
            unselectedItemColor: const Color(0xFF94A3B8),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Tracker',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                activeIcon: Icon(Icons.chat),
                label: 'Consult',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ─────────────────────────────────────────────────────────
   PAGE 1: Patient Dashboard (Consultations & Top Doctors)
───────────────────────────────────────────────────────── */
class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  int _selectedSpecialistIndex = 0;

  final List<Map<String, dynamic>> _specialists = [
    {'name': 'Neurologist', 'icon': Icons.psychology},
    {'name': 'Cardiologist', 'icon': Icons.favorite},
    {'name': 'Pulmonologist', 'icon': Icons.air},
    {'name': 'Orthopedist', 'icon': Icons.accessibility},
  ];

  // Dummy Doctor Model matching mockup exactly
  final DoctorModel _doctorWilliam = DoctorModel(
    id: 'doc_1',
    name: 'Dr. William James',
    category: 'Neurologist',
    imageUrl: '',
    rating: 4.8,
    sessionFee: 95.0,
    availability: [
      AvailabilitySlot(dayName: 'Mon', dayNumber: '16', slotText: '8 slots'),
      AvailabilitySlot(dayName: 'Tue', dayNumber: '17', slotText: '4 slots'),
      AvailabilitySlot(dayName: 'Wed', dayNumber: '18', slotText: '12 slots'),
      AvailabilitySlot(dayName: 'Thu', dayNumber: '19', slotText: '6 slots'),
      AvailabilitySlot(dayName: 'Fri', dayNumber: '20', slotText: '9 slots'),
      AvailabilitySlot(dayName: 'Sat', dayNumber: '21', slotText: '2 slots'),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello Rakib 👋',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'How are you today?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.search, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search input field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  hintText: 'Search doctor, medicine, or clinic...',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Specialists header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Specialists',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Specialist horizontal scroll
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _specialists.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedSpecialistIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSpecialistIndex = index),
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _specialists[index]['icon'],
                            color: isSelected ? Colors.white : const Color(0xFF2563EB),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _specialists[index]['name'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // Top Doctors Section
            const Text(
              'Top Doctors',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            // Doctor Card Component Usage
            DoctorCard(
              doctor: _doctorWilliam,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorProfileDetailPage(
                      name: 'Dr. William James',
                      category: 'Neurologist',
                      fee: '\$95',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────────────────────────────────────
   PAGE 2: Health Tracking (ECG, SpO2, Heart, Suggested Meal)
───────────────────────────────────────────────────────── */
class HealthTrackingPage extends StatelessWidget {
  const HealthTrackingPage({super.key});

  // Dummy weight log model
  final WeightLog _weightLog = const WeightLog(
    currentWeight: 72,
    lostWeight: 18,
    totalCalories: '170k',
  );

  // Dummy suggested meal model
  final MealModel _suggestedMeal = const MealModel(
    title: 'Green Grill Boost',
    calories: '290',
    category: 'High Protein Diet',
    description: 'A light protein lunch for those who appreciate taste and form. Grilled chicken breast served with avocado slices, green broccoli florets, and light dressing.',
    proteinGrams: 36,
    carbsGrams: 9,
    fatGrams: 10,
    chefName: 'Coash Criss Bumbter',
    chefRating: 4.7,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello, Olga',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text('Check your stats today', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calendar_month, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Steps circular progress widget usage
              const StepsCircleProgress(
                currentSteps: 10781,
                targetPercentage: 0.72,
              ),
              const SizedBox(height: 16),

              // Stats Row (Heart, SpO2, Calories)
              Row(
                children: [
                  const Expanded(
                    child: MetricCard(
                      label: 'Heart Rate',
                      value: '72 bpm',
                      icon: Icons.favorite,
                      iconColor: Color(0xFFF43F5E),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: MetricCard(
                      label: 'SpO2 Level',
                      value: '96%',
                      icon: Icons.bubble_chart,
                      iconColor: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildLocalMetricTile(
                      label: 'Calories',
                      val: '1,478 kcal',
                      icon: Icons.local_fire_department,
                      col: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Heart Rate ECG Analysis Chart widget usage
              const EcgAnalysisChart(),
              const SizedBox(height: 20),

              // Activity tracker custom bar chart widget usage
              Container(
                height: 220,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: ActivityTrackerChart(
                  weeklyData: [0.35, 0.45, 0.38, 0.62, 0.85, 0.52, 0.40],
                ),
              ),
              const SizedBox(height: 20),

              // Weight tracker blocks widget usage
              WeightTrackerCard(weightLog: _weightLog),
              const SizedBox(height: 20),

              // Overall strength score widget usage
              StrengthScoreCard(
                score: 1490,
                rank: 2,
                onTap: () {},
              ),
              const SizedBox(height: 20),

              // Suggested meal card widget usage
              const Text(
                'Suggested Meal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SuggestedMealCard(
                meal: _suggestedMeal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailPage(meal: _suggestedMeal),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocalMetricTile({
    required String label,
    required String val,
    required IconData icon,
    required Color col,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: col, size: 20),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }
}

/* ─────────────────────────────────────────────────────────
   PAGE 3: Doctor Consultation Hub
───────────────────────────────────────────────────────── */
class DoctorConsultationPage extends StatelessWidget {
  const DoctorConsultationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Video Consultation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 4),
                ),
                child: const Icon(Icons.video_call, color: Color(0xFF2563EB), size: 72),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Active Video Call Session',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),
              Text(
                'Schedule a consultation or start a direct tele-call session with available doctors in your facility.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CallScreen(doctorName: 'Dr. Nick Tyler'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: const Text('Start Call with Dr. Nick Tyler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ─────────────────────────────────────────────────────────
   PAGE 4: Doctor Profile Details Page
───────────────────────────────────────────────────────── */
class DoctorProfileDetailPage extends StatelessWidget {
  final String name;
  final String category;
  final String fee;

  const DoctorProfileDetailPage({
    super.key,
    required this.name,
    required this.category,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Color(0xFF1E293B)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_outlined, color: Color(0xFF1E293B)), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar & Name Card
            Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.person, size: 54, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      const SizedBox(height: 4),
                      Text('MBBS, MD, Fellowship in Cardiology\n$fee / session', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistics Row (Experience, Rating, Patients)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('12 years', 'Experience'),
                _buildStatItem('4.8 ★', 'Rating'),
                _buildStatItem('2,500+', 'Patients'),
              ],
            ),
            const SizedBox(height: 24),

            // Doctor description bio
            const Text('About Doctor', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            Text(
              'Dr. William James is a board-certified specialist with over 12 years of clinical research experience in advanced diagnosis and therapeutic care. He focuses on comprehensive health evaluations and patient-first treatment plans.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Fees information row
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Session Fee', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(height: 4),
                      Text('$fee.00', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Follow-Up Fee', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(height: 4),
                      const Text('\$40.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // CTA Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallScreen(doctorName: name),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Book Video Call Consultation', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2563EB))),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

/* ─────────────────────────────────────────────────────────
   PAGE 5: Video Call Consultation Simulator Screen
───────────────────────────────────────────────────────── */
class CallScreen extends StatefulWidget {
  final String doctorName;

  const CallScreen({super.key, required this.doctorName});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B), // Dark video bg
      body: SafeArea(
        child: Stack(
          children: [
            // Full screen doctor avatar background
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 6),
                    ),
                    child: const Icon(Icons.person, size: 72, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.doctorName,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fiber_manual_record, color: Color(0xFF10B981), size: 10),
                      SizedBox(width: 6),
                      Text('Connected (14:10)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            // Top control bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Doctor small floating corner window (simulating remote feed)
                  Container(
                    width: 64,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Icon(Icons.person, color: Colors.white30, size: 28),
                  ),
                ],
              ),
            ),

            // Bottom Call Action Controls Overlay
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute Button
                    IconButton(
                      icon: Icon(
                        _isMuted ? Icons.mic_off : Icons.mic,
                        color: _isMuted ? Colors.red : Colors.white,
                      ),
                      onPressed: () => setState(() => _isMuted = !_isMuted),
                    ),
                    // Video Toggle Button
                    IconButton(
                      icon: Icon(
                        _isVideoOff ? Icons.videocam_off : Icons.videocam,
                        color: _isVideoOff ? Colors.red : Colors.white,
                      ),
                      onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                    ),
                    // End Call Action Button
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.call_end, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    // Sound output selector
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────────────────────────────────────
   PAGE 6: Profile & Settings page
───────────────────────────────────────────────────────── */
class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // User header profile info
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF2563EB),
                child: Text(
                  'RO',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Rakib Kowshar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('hellorakib.rk@gmail.com', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 24),

              // Settings Items List
              _buildSettingsCard(
                items: [
                  _buildSettingsRow(Icons.person_outline, 'Personal Information'),
                  _buildSettingsRow(Icons.payment, 'Payment Methods'),
                  _buildSettingsRow(Icons.history, 'Consultation History'),
                  _buildSettingsRow(Icons.settings_outlined, 'Account Settings'),
                ],
              ),
              const SizedBox(height: 16),
              _buildSettingsCard(
                items: [
                  _buildSettingsRow(Icons.help_outline, 'FAQ & Help Center'),
                  _buildSettingsRow(Icons.security, 'Privacy Policy'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 22),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}
