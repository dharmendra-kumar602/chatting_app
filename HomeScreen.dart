import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/chattingApp/ChatRoom.dart';
import 'package:firebase/chattingApp/CreateAccount.dart';
import 'package:firebase/chattingApp/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group_chat/group_chat_room.dart';
import 'group_chat/group_chat_screen.dart';
class HomeScreen extends StatefulWidget  {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with WidgetsBindingObserver {

  String chatRoooId(String user1,String user2){
    if(user1[0].toLowerCase().codeUnits[0]>user2[0].toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }else{
      return "$user2$user1";
    }
  }

   late Map<String,dynamic> userMap;
   var userName;
   var userEmail;
   bool  isLoading = false;
    TextEditingController _search = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

      void onSearch() async{
        setState(() {
          isLoading = true;

        });
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        await _firestore.collection('users').where("email",isEqualTo:_search.text).get().then((value) {
          setState(() {
            userMap =value.docs[0].data();
            isLoading = false;

          });
        });
        print(userMap);
        userName = userMap['name'];
        userEmail = userMap['email'];
        print(userMap["email"]);
      }


      @override
     void initState() {
      super.initState();
      WidgetsBinding.instance.addObserver(this);
      setStatus("Online");

      }

   FirebaseFirestore _firestoreStatus = FirebaseFirestore.instance;
      void setStatus(String status) async{
        await _firestoreStatus.collection('users').doc(_auth.currentUser?.uid).update({
          "status": status,
        });
      }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
        if(state == AppLifecycleState.resumed){
        // when user is online then show
          setStatus("Online");
        }else{
          // when user offline then show
          setStatus("Offline");
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Home Screen"),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 30,
                width: 110,
                child: Text("${userEmail}",)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions:  [
          IconButton(onPressed: (){
            logOut(context);
          },icon: const Icon(Icons.logout),)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading ? const Center(
          child: CircularProgressIndicator(),
        ): Column(
          children: [
          const SizedBox(height: 50,),
            // actionButton('LogOut'),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'search here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                onPressed: (){
                  onSearch();
            }, child: const Text('Search')),
            GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) =>CreateAccount()));
              },
              child: const Text('Create Account',style: TextStyle(color: Colors.deepPurpleAccent),),
            ),
            Text(userName.toString()),
            ListTile(
                    onTap: (){
                      String roomId = chatRoooId(_auth.currentUser!.displayName.toString(), userMap["name"]);
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>ChatRoom(ChatRoomId:roomId ,userMap: userMap,)));
                    },
            leading: const Icon(Icons.account_box,color: Colors.black,),
            title: Text(userName.toString(),style: TextStyle(color: Colors.black),),
            subtitle: Text(userEmail.toString()),
            trailing: const Icon(Icons.chat,color: Colors.black,),
          ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) =>  GroupChatRoom()));
        },
      ),
    );
  }
  Widget actionButton(String buttonTitle,){
    return Container(
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: GestureDetector(
        child: Center(child: Text(buttonTitle,style: const TextStyle(color: Colors.deepPurple),)),
        onTap: (){
          logOut(context);
        },
      ),

    );
  }


}
