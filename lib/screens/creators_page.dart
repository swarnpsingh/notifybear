import 'package:flutter/material.dart';
import 'package:notifybear/screens/shopping_cart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../shared/my_colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/platform_button.dart';
import '../widgets/side_menu_panel.dart';

class CreatorPage extends StatefulWidget {
  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  final PanelController _panelController = PanelController();
  String selectedPlatform = 'YouTube';

  void _onPlatformSelected(String platform) {
    setState(() {
      selectedPlatform = platform;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: SlidingUpPanel(
        controller: _panelController,
        panel: sideMenuPanel(),
        body: _buildMainContent(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          bottomLeft: Radius.circular(24.0),
        ),
        defaultPanelState: PanelState.CLOSED,
        maxHeight:
            MediaQuery.of(context).size.width * 0.5, // Adjust width as needed
        minHeight: 0,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        backdropEnabled: true,
        backdropOpacity: 0.5,
        slideDirection: SlideDirection.UP, // Slide from right
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: MyColors.getBackgroundGradient(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              Builder(builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  iconSize: 35,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                iconSize: 35,
                onPressed: () {
                  // Implement cart button functionality
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShoppingCart()));
                },
              ),
            ],
          ),
          _buildCreatorProfile(),
          _buildTabs(),
          _buildNotificationsList(),
        ],
      ),
    );
  }

  Widget _buildCreatorProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.red,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        SizedBox(height: 10),
        Text(
          'CreatorName',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        Text(
          'I make videos.',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlatformButton(
              platform: 'YouTube',
              iconPath: 'assets/youtube.png',
              isSelected: selectedPlatform == 'YouTube',
              onPressed: () => _onPlatformSelected('YouTube'),
            ),
            SizedBox(width: 10),
            PlatformButton(
              platform: 'Twitch',
              iconPath: 'assets/twitch.png',
              isSelected: selectedPlatform == 'Twitch',
              onPressed: () => _onPlatformSelected('Twitch'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return DefaultTabController(
      length: 4,
      child: TabBar(
        tabs: [
          Tab(text: 'Notifications'),
          Tab(text: 'Originals'),
          Tab(text: 'Timeline'),
          Tab(text: 'Platforms'),
        ],
        labelColor: Colors.white, // Selected tab text color
        unselectedLabelColor: Colors.white, // Unselected tab text color
        indicatorColor:
            Color.fromRGBO(0, 210, 255, 1), // Optional: Tab indicator color
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Expanded(
      child: ListView(
        children: [
          _buildNotificationItem(
            title: 'Live Stream',
            subtitle: 'Creator is live streaming now',
            isLive: true,
          ),
          _buildNotificationItem(
            title: 'New Video',
            subtitle: 'Check out the latest upload',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      {required String title, required String subtitle, bool isLive = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.play_arrow, color: Colors.white),
      ),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      trailing: isLive
          ? Chip(label: Text('LIVE'), backgroundColor: Colors.red)
          : null,
    );
  }
}
