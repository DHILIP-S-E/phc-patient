import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/clinical_models.dart';
import '../state/auth_provider.dart';
import '../theme/app_theme.dart';
import '../components/app_icon.dart';

/// GET /patients/me/notifications. Screen-local — no other screen needs the
/// notification feed, so the provider lives next to its only consumer.
final _notificationsProvider = FutureProvider<List<NotificationItem>>((ref) {
  return ref.watch(patientPortalRepositoryProvider).getNotifications();
});

/// Reverse-chronological list of the patient's notifications (SMS/WhatsApp/
/// push messages sent by the facility), as simple list tiles.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(_notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.ink),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_notificationsProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: notifications.when(
          data: (items) {
            if (items.isEmpty) return const _EmptyNotificationsState();
            final sorted = [...items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: sorted.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _NotificationTile(item: sorted[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load notifications.\n$error',
                textAlign: TextAlign.center,
                style: AppText.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final channel = _channelInfo(item.channel);
    final status = _statusInfo(item.status);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: channel.color.withOpacity(0.12), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: AppIcon(name: channel.iconName, fallback: channel.fallback, color: channel.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.messageText,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_titleCase(item.module)} · ${_formatDateTime(item.createdAt)}',
                  style: AppText.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: status.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Text(
              _titleCase(item.status),
              style: TextStyle(color: status.color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotificationsState extends StatelessWidget {
  const _EmptyNotificationsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const AppIcon(name: 'bell', fallback: Icons.notifications_none, color: AppColors.primary, size: 60),
          ),
          const SizedBox(height: 24),
          const Text(
            'No notifications yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
          const SizedBox(height: 8),
          const Text(
            'Updates about your visits, tests, and referrals will show up here.',
            textAlign: TextAlign.center,
            style: AppText.body,
          ),
        ],
      ),
    );
  }
}

class _ChannelInfo {
  final String iconName;
  final IconData fallback;
  final Color color;

  const _ChannelInfo(this.iconName, this.fallback, this.color);
}

/// Maps `notifications.channel` (free-text on the backend, e.g. `WHATSAPP`,
/// `SMS` — see phc_api/models/notification.py) to an icon + tint.
_ChannelInfo _channelInfo(String channel) {
  switch (channel.toUpperCase()) {
    case 'WHATSAPP':
      return const _ChannelInfo('whatsapp', Icons.chat_bubble_outline, Color(0xFF25D366));
    case 'SMS':
      return const _ChannelInfo('sms', Icons.sms_outlined, AppColors.primary);
    case 'PUSH':
      return const _ChannelInfo('bell', Icons.notifications_active_outlined, AppColors.teal);
    case 'IVR':
    case 'CALL':
      return const _ChannelInfo('phone', Icons.call_outlined, Colors.orange);
    default:
      return const _ChannelInfo('bell', Icons.notifications_none, AppColors.muted);
  }
}

class _StatusInfo {
  final Color color;

  const _StatusInfo(this.color);
}

/// Maps `notifications.status` (`PENDING` / `SENT` / `FAILED`, see
/// phc_api/models/notification.py) to a badge tint.
_StatusInfo _statusInfo(String status) {
  switch (status.toUpperCase()) {
    case 'SENT':
      return const _StatusInfo(Color(0xFF10B981));
    case 'FAILED':
      return const _StatusInfo(Color(0xFFF43F5E));
    case 'PENDING':
      return const _StatusInfo(Color(0xFFF59E0B));
    default:
      return const _StatusInfo(AppColors.muted);
  }
}

/// "AI_ALERTS" -> "Ai Alerts". Backend module/status fields are free-text
/// SNAKE_CASE (see phc_api/models/notification.py).
String _titleCase(String raw) {
  return raw
      .split('_')
      .where((w) => w.isNotEmpty)
      .map((w) => '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
      .join(' ');
}

/// Formats an ISO datetime string as e.g. "8 Jul, 10:15 AM" without pulling
/// in intl (not a project dependency) — DateTime.tryParse handles ISO 8601.
String _formatDateTime(String iso) {
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return iso;
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  final minute = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${months[dt.month - 1]}, $hour12:$minute $period';
}
