// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CallBackDropDown extends StatefulWidget {
  const CallBackDropDown({super.key, required this.onUserselected});

  final void Function(CallBackUser user) onUserselected;

  @override
  State<CallBackDropDown> createState() => _CallBackDropDownState();
}

class _CallBackDropDownState extends State<CallBackDropDown> {
  CallBackUser? _users;
  

  void _updateUser(CallBackUser? item) {
    setState(() {
      _users = item;
    });

    if (_users != null) {
      widget.onUserselected.call(_users!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: DropdownButton<CallBackUser>(
        hint: Text("Durum"),
        disabledHint: Text("Disable hint"),
        value: _users,
        items: CallBackUser.dummyUsers().map((e) {
          return DropdownMenuItem(
            child: Text(e.name),
            value: e,
          );
        }).toList(),
        onChanged: _updateUser,
      ),
    );
  }
}

class CallBackUser {
  final String name;
  final int id;
  CallBackUser(this.name, this.id);

  static List<CallBackUser> dummyUsers() {
    return [
      CallBackUser("kötü", 1),
      CallBackUser("orta", 2),
      CallBackUser("iyi", 3),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallBackUser && other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
