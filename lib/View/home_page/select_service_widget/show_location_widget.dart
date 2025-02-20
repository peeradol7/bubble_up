import 'package:flutter/material.dart';

class ShowLocationWidget extends StatefulWidget {
  const ShowLocationWidget({super.key});

  @override
  State<ShowLocationWidget> createState() => _ShowLocationWidgetState();
}

class _ShowLocationWidgetState extends State<ShowLocationWidget> {
  @override
  Widget build(BuildContext context) {
    const appbar = Color(0xFF01B9E4);
    return SliverAppBar(
      elevation: 0,
      backgroundColor: appbar,
      expandedHeight: 150,
      pinned: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.0,
        background: Container(
          decoration: BoxDecoration(
            color: appbar,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Add spacing from top
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 20,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        titlePadding: EdgeInsets.zero, // Remove default title padding
      ),
    );
  }
}
