import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/notifications/notifications_repo.dart';
import 'package:we_teach/services/local_notification_service.dart';
import 'package:we_teach/services/secure_storage_service.dart';
import 'dart:convert';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsRepository _notificationsRepository =
      NotificationsRepository();
  final SecureStorageService _secureStorageService = SecureStorageService();

  List<Map<String, dynamic>> _notifications = [];
  int? _ownerId;
  bool _isLoading = false;
  String? _errorMessage;

  // Set to track processed notification IDs
  Set<int> _processedNotificationIds = {};

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NotificationsProvider() {
    _loadProcessedNotificationIds();
  }

  // Load processed notification IDs from secure storage
  Future<void> _loadProcessedNotificationIds() async {
    try {
      String? processedIds =
          await _secureStorageService.getProcessedNotificationIds();
      if (processedIds != null && processedIds.isNotEmpty) {
        List<dynamic> ids = jsonDecode(processedIds);
        _processedNotificationIds = ids.map<int>((id) => id as int).toSet();
        debugPrint(
            'Loaded processed notification IDs: $_processedNotificationIds');
      }
    } catch (e) {
      debugPrint('Error loading processed notification IDs: $e');
    }
  }

  // Save processed notification IDs to secure storage
  Future<void> _saveProcessedNotificationIds() async {
    try {
      String processedIds = jsonEncode(_processedNotificationIds.toList());
      await _secureStorageService.storeProcessedNotificationIds(processedIds);
      debugPrint('Saved processed notification IDs: $processedIds');
    } catch (e) {
      debugPrint('Error saving processed notification IDs: $e');
    }
  }

  /// Fetch notifications from the API
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Map<String, dynamic>> fetchedNotifications =
          await _notificationsRepository.fetchNotifications();

      if (fetchedNotifications.isNotEmpty) {
        _ownerId = fetchedNotifications.first['owner']['id'];
      }

      // Filter out notifications that are already viewed
      _notifications = fetchedNotifications
          .where((notification) => notification['is_viewed'] == false)
          .toList();
    } catch (error) {
      debugPrint('Error fetching notifications: $error');
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check for new notifications and show them
  Future<void> checkAndShowNewNotifications() async {
    // Make sure notifications are loaded first
    if (_notifications.isEmpty && !_isLoading) {
      await fetchNotifications();
    }

    // Process notifications to show only new ones
    await _showNewNotifications();
  }

  /// Show notifications only for new items
  Future<void> _showNewNotifications() async {
    for (var notification in _notifications) {
      int notificationId = notification['id'];

      // Check if we've already processed this notification
      if (!_processedNotificationIds.contains(notificationId)) {
        debugPrint('Showing new notification: ${notification['title']}');

        // Show the notification
        await LocalNotificationService.showNotification(
          id: notificationId,
          title: notification['title'],
          body: notification['message'],
        );

        // Mark this notification as processed
        _processedNotificationIds.add(notificationId);
      }
    }

    // Save updated processed IDs to storage
    await _saveProcessedNotificationIds();
  }

  /// Mark selected notifications as read
  Future<void> markSelectedAsRead(List<int> notificationIds) async {
    if (_ownerId == null || notificationIds.isEmpty) return;

    try {
      await _notificationsRepository.updateNotification(
        ownerId: _ownerId!,
        notificationIds: notificationIds,
      );

      // Remove notifications that were marked as read
      _notifications.removeWhere((n) => notificationIds.contains(n['id']));
      notifyListeners();
    } catch (error) {
      _errorMessage = "Failed to update notifications: $error";
      notifyListeners();
    }
  }

  /// Mark a notification as unread (blue dot remains)
  void markAsUnread(int notificationId) {
    int index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['is_viewed'] = false;
      notifyListeners();
    }
  }
}
