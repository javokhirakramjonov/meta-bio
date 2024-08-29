import 'package:flutter/material.dart';

class CustomTab extends StatefulWidget {
  const CustomTab({super.key});

  @override
  _CustomTabState createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300, // Set the desired height
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
                Tab(text: 'Tab 3'),
              ],
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _tabController.animateTo(index);
                },
                children: [
                  Center(child: Text('Content for Tab 1')),
                  Center(child: Text('Content for Tab 2')),
                  Center(child: Text('Content for Tab 3')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
