import 'package:firebase/chattingApp/group_chat/group_chat_screen.dart';
import 'package:flutter/material.dart';
class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BackButton(),
            ),
            Container(
              height: size.height/8,
              width: size.width/1.2,
              child: Row(
                children: [
                  Container(
                    height:size.height/12,
                      width:size.width/12 ,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Icon(Icons.group,size:20,)
                  ),
                  const SizedBox(width: 20,),
                  const Text('group Name',style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              child: Text('60 members',style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),),
            ),
            const SizedBox(height: 20,),

            Container(
              height: 400,
              child: Flexible(
                flex: 2,
                  child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("user1${index}"),
                  );
                },
              )),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => GroupChatScreen()));
              },
              leading: Icon(Icons.logout),
              title: Text("Leave Group",style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),),
            )
          ],
        ),
      ),
    );
  }
}
