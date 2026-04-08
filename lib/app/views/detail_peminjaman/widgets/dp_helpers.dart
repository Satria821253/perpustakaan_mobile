import 'package:flutter/material.dart';
import 'package:ei_books/app/widgets/app_shared_widgets.dart';
export 'package:ei_books/app/widgets/app_shared_widgets.dart';

BoxDecoration dpCardDecor() => appCardDecor();
String dpFmt(int n) => appFmt(n);
Widget dpSectionTitle(String t) => appSectionTitle(t);
typedef DpDetailRow = AppInfoRow;
