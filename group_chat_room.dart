import 'package:firebase/chattingApp/group_chat/group_info.dart';
import 'package:flutter/material.dart';
class GroupChatRoom extends StatelessWidget {
   GroupChatRoom({super.key});

   String currentUserName= "user1";
 final TextEditingController _messageController = TextEditingController();

  List<Map<String,dynamic>> dummyChatList = [

    {
      "message":"User creates this group",
      "type":"notify",
    },
    {
      "message":"hello This is user user1 ",
      "sendBy":"user1",
      "type":"text",
    },

    {
      "message":"hello This is user user2 ",
      "sendBy":"user2",
      "type":"text",
    },

    {
      "message":"hello This is user user3 ",
      "sendBy":"user3",
      "type":"text",
    },

    {
      "message":"hello This is user user4 ",
      "sendBy":"user4",
      "type":"text",
    },

    {
      "message":"user 1 added  user 5 is user user 5 ",
      "type":"notify",
    },



 ];

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Name'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) =>GroupInfo()));

          }, icon: const Icon(Icons.more_vert))
        ],
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: size.height/2,
              width: double.infinity,
              child: ListView.builder(
                   itemCount:dummyChatList.length ,
                  itemBuilder: (BuildContext context,int index){
                     return messageTitle(size ,dummyChatList[index]);
                  }
                  ),
            ),

          Container(
            height: 40,
            width: 500,
            alignment: Alignment.center,
            child: Center(
              child: Container(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 300,
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {

                              },
                              icon: Icon(Icons.photo),),
                            hintText: 'Typing...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {
                      // messageTitle(size,chatMap);
                    }, icon: const Icon(Icons.send),)
                  ],
                ),
              ),
            ),
          ),
      ],
        ),
      ),
    );
  }

  Widget messageTitle(Size size, Map<String,dynamic> chatMap){
    return Builder(
        builder: (_){
          if(chatMap["type"] == "text"){
            return Container(
              height: 150,
              width: 400,
              alignment: chatMap['sendBy'] == currentUserName ? Alignment.centerRight : Alignment.centerLeft,
              padding:  EdgeInsets.symmetric(
                horizontal: size.width/50,
                vertical: size.width /40,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    Text(chatMap['sendBy']),
                    Text(chatMap['message'].toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }else if(chatMap['type']=="img"){

            return Container(
              height: 120,
              width: 400,
              alignment: chatMap['sendBy'] == currentUserName ? Alignment.centerRight : Alignment.centerLeft,
              padding:  EdgeInsets.symmetric(
                horizontal: size.width/50,
                vertical: size.width /40,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Image.network(chatMap['message']

                ),
              ),
            );
          }else if(chatMap['type'] == "notify"){
              return Container(
                height: 130,
                width: 400,
                alignment: Alignment.center,
                padding:  EdgeInsets.symmetric(
                  horizontal: size.width/50,
                  vertical: size.width /40,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: Text(chatMap['message'].toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              );
          } else{
            return const SizedBox();
          }
    });
  }


}
