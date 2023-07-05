import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefencesDialog {

  Widget buildDialog(BuildContext context, int members, int episodes) {

    return AlertDialog(
      title: Text("COUNTS"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Text("Members count"),
                Text(members.toString())
              ],
            ),
            Column(
              children: [
                Text("Episodes count"),
                Text(episodes.toString())
              ],
            ),
          ],
        ),
      ),
    );
  }

}
