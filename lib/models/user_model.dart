// lib/models/app_user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? avatar;
  final int bestScore;
  final int totalScore;
  final int gamesPlayed;
  final List<dynamic> history;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.avatar,
    required this.bestScore,
    required this.totalScore,
    required this.gamesPlayed,
    required this.history,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      avatar: data['avatar'],
      bestScore: data['bestScore'] ?? 0,
      totalScore: data['totalScore'] ?? 0,
      gamesPlayed: data['gamesPlayed'] ?? 0,
      history: data['history'] ?? [],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'avatar': avatar,
    'bestScore': bestScore,
    'totalScore': totalScore,
    'gamesPlayed': gamesPlayed,
    'history': history,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory UserModel.initial({
    required String uid,
    required String name,
    required String email,
  }) {
    final now = Timestamp.now();
    return UserModel(
      uid: uid,
      email: email,
      name: name,
      avatar: null,
      bestScore: 0,
      totalScore: 0,
      gamesPlayed: 0,
      history: [],
      createdAt: now,
      updatedAt: now,
    );
  }
}
