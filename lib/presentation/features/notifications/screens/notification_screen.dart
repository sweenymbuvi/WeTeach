import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:we_teach/gen/assets.gen.dart';
import 'package:we_teach/presentation/features/notifications/provider/notifications_provider.dart';
import 'package:we_teach/presentation/shared/widgets/bottom_nav_bar.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_options.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _currentIndex = 3;
  int _selectedCount = 0; // Track selected notifications
  Set<int> selectedItems = {}; // Store selected notification IDs

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<NotificationsProvider>(context, listen: false)
            .fetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              _selectedCount > 0
                  ? '$_selectedCount ${_selectedCount == 1 ? 'notification' : 'notifications'} selected'
                  : 'Your Notifications',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTapDown: (details) =>
                  _showNotificationOptions(context, details),
              child: SvgPicture.asset(
                Assets.svg.more, // Use the generated asset class
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<NotificationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          List<Map<String, dynamic>> todayNotifications = [];
          List<Map<String, dynamic>> thisMonthNotifications = [];
          List<Map<String, dynamic>> earlierNotifications = [];

          DateTime now = DateTime.now();
          for (var notification in provider.notifications) {
            DateTime creationTime =
                DateTime.parse(notification['creation_time']);

            if (creationTime.day == now.day &&
                creationTime.month == now.month &&
                creationTime.year == now.year) {
              todayNotifications.add(notification);
            } else if (creationTime.month == now.month &&
                creationTime.year == now.year) {
              thisMonthNotifications.add(notification);
            } else {
              earlierNotifications.add(notification);
            }
          }

          return ListView(
            children: [
              _buildNotificationSection('Today', todayNotifications),
              _buildNotificationSection('This Month', thisMonthNotifications),
              _buildNotificationSection('Earlier', earlierNotifications),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void _showNotificationOptions(BuildContext context, TapDownDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          child: NotificationOptions(
            onMarkAsRead: () {
              Navigator.pop(context);
              _markSelectedAsRead();
            },
            onMarkAsUnread: () {
              Navigator.pop(context);
              _markSelectedAsUnread();
            },
          ),
        ),
      ],
      elevation: 8,
      color: Colors.transparent,
    );
  }

  /// Marks selected notifications as read
  void _markSelectedAsRead() {
    if (selectedItems.isEmpty) return;

    // Call the provider to mark as read
    Provider.of<NotificationsProvider>(context, listen: false)
        .markSelectedAsRead(selectedItems.toList());

    // Reset selection
    setState(() {
      _selectedCount = 0;
      selectedItems.clear();
    });
  }

  /// Marks selected notifications as unread
  void _markSelectedAsUnread() {
    for (var id in selectedItems) {
      Provider.of<NotificationsProvider>(context, listen: false)
          .markAsUnread(id);
    }

    setState(() {
      _selectedCount = 0;
      selectedItems.clear();
    });
  }

  Widget _buildNotificationSection(
      String title, List<Map<String, dynamic>> notifications) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          if (notifications.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title == 'Today'
                    ? 'No new notifications for today'
                    : title == 'This Month'
                        ? 'No new notifications for this month'
                        : 'No new notifications from earlier',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ...notifications.map((notification) => NotificationTile(
                title: notification['title'],
                timeAgo: timeago
                    .format(DateTime.parse(notification['creation_time'])),
                onSelectionChanged: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedCount++;
                      selectedItems.add(notification['id']);
                    } else {
                      _selectedCount =
                          _selectedCount > 0 ? _selectedCount - 1 : 0;
                      selectedItems.remove(notification['id']);
                    }
                  });
                },
              )),
        ],
      ),
    );
  }
}
