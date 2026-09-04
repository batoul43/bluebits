import 'package:flutter/material.dart';

bool isopen = false;
int countSubject = 0;

// متغير لتتبع عدد المهام المنجزة في كامل التطبيق
final ValueNotifier<int> completedTasksNotifier = ValueNotifier<int>(0);
