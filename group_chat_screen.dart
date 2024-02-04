import 'package:firebase/chattingApp/create_group/add_member.dart';
import 'package:firebase/chattingApp/group_chat/group_chat_room.dart';
import 'package:flutter/material.dart';
class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        backgroundColor: Colors.deepPurple,

      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => GroupChatRoom()));
              },
              leading: const Icon(Icons.group),
              title: Text("Group $index"),
            );
          }
          ),
      floatingActionButton: FloatingActionButton(
        child:  Icon(Icons.create),
        tooltip: "Create Group",
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => AddMemberInGroup()));

        },
      ),
    );
  }
}
