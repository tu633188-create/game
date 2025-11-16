import 'package:flutter/material.dart';

class GameInfo {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<String> integrationLocations; // Vị trí tích hợp
  final List<String> benefits; // Tác dụng
  final String rewardMechanism; // Cơ chế reward
  final List<String> bestPractices; // Best practices
  final List<String> adminManagement; // Quản lý Admin

  GameInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.integrationLocations,
    required this.benefits,
    required this.rewardMechanism,
    required this.bestPractices,
    required this.adminManagement,
  });
}

