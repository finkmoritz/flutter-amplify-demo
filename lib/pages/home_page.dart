import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/pages/analytics/analytics_page.dart';
import 'package:flutter_amplify_demo/pages/auth/auth_page.dart';
import 'package:flutter_amplify_demo/pages/auth/auth_status.dart';
import 'package:flutter_amplify_demo/pages/data_store/data_store_page.dart';
import 'package:flutter_amplify_demo/pages/storage/storage_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController;

  AuthPage _authPage;
  DataStorePage _dataStorePage;
  AnalyticsPage _analyticsPage;
  StoragePage _storagePage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _authPage = AuthPage();
    _dataStorePage = DataStorePage();
    _analyticsPage = AnalyticsPage();
    _storagePage = StoragePage();
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
        actions: [
          AuthStatus(),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() {
          _currentIndex = index;
        }),
        children: [
          _authPage,
          _dataStorePage,
          _analyticsPage,
          _storagePage,
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
            label: 'Data Store',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Storage',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
