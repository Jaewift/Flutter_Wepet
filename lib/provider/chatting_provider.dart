import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chatting_cache {
  final Widget image;
  final String name;
  final String chatting_content;
  final String time;

  Chatting_cache(this.image, this.name, this.chatting_content, this.time);
}

class Chatting_provider extends StateNotifier<List<Chatting_cache>> {
  Chatting_provider() : super(const []);

  final ChattingStateNotifierProvider = StateNotifierProvider<Chatting_provider, List<Chatting_cache>>((ref) {
    return Chatting_provider();
  });

}