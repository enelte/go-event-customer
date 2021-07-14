import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kPrimaryGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Colors.blueGrey, kPrimaryColor],
);
const avatarImage = NetworkImage(
    "https://media.istockphoto.com/vectors/anonymous-gender-neutral-face-avatar-incognito-head-silhouette-vector-id1220827245?k=6&m=1220827245&s=170667a&w=0&h=iqDUB2wUcXChyYIm9wzBm40YodlBQ4iGqGE-5C2Qwf0=");

const Map<String, IconData> iconMapping = {
  'Venue': Icons.location_city,
  'Talent': Icons.music_note,
  'Catering': Icons.fastfood,
  '': Icons.person
};
