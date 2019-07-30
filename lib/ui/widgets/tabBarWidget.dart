import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({
    Key key, @required this.tabIndex
  }) : super(key: key);

  final int tabIndex;

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.tabIndex,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: Colors.black.withOpacity(0.75),
      selectedItemColor: Color(0xFFFFD500),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Winkels'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profiel'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          title: Text('Nieuws'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat), title: Text("Service"))
      ],
      onTap: (index) {
        

      },
    );
  }
}
