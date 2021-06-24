import 'package:flutter/material.dart';

Widget displayName(String title, String text1, String text2) => Column(
      //ini harusnya di tambahin User user di params nya
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          text1,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          text2,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
