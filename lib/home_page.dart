import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/pages/analytics/analytics_page.dart';
import 'package:flutter_amplify_demo/pages/auth/auth_page.dart';
import 'package:flutter_amplify_demo/pages/chat/chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController;

  AuthPage _authPage;
  ChatPage _chatPage;
  AnalyticsPage _analyticsPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _authPage = AuthPage();
    _chatPage = ChatPage();
    _analyticsPage = AnalyticsPage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Amplify Demo'),
        automaticallyImplyLeading: false,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() {
          _currentIndex = index;
        }),
        children: [
          _authPage,
          _chatPage,
          _analyticsPage,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut
          );
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Auth',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
