import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/chattingApp/create_group/create_group_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
class AddMemberInGroup extends StatefulWidget {
  const AddMemberInGroup({super.key});

  @override
  State<AddMemberInGroup> createState() => _AddMemberInGroupState();
}

class _AddMemberInGroupState extends State<AddMemberInGroup> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth= FirebaseAuth.instance;


  bool isLoading = false;
 final TextEditingController _search = TextEditingController();

 Map<String,dynamic> ? userMap={};
  List<Map<String,dynamic>> memberList = [

  ];

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }
  void getCurrentUserDetails() async{
    await _firestore.collection('users').doc(_auth.currentUser!.uid).get().then((map) {
      setState(() {
        memberList.add(
            {
              "name": map["name"],
              "email": map["email"],
              "uid": map["uid"],
              "isAdmin": true,
            }
        );
      });
    });
  }


  void onSearch() async{
    setState(() {
      isLoading = true;
    });

    await _firestore.collection('users').where("email",isEqualTo:_search.text).get().then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;

      });
    });
    print(userMap);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
        backgroundColor: Colors.deepPurple,
      ),
      body:  SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 400,
              child: Flexible(
                flex: 2,
                  child: ListView.builder(
                      itemCount: memberList.length,
                      itemBuilder: (context,index){
                    return ListTile(
                      onTap: (){},
                      leading: const Icon(Icons.account_circle),
                      title:  Text(memberList[index]['name']),
                      subtitle: Text(memberList[index]['email']),
                      trailing: const Icon(Icons.close),
                    );
                  }
                  )
              ),
            ),
            const SizedBox(height: 50,),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextField(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.forward),onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => const CreateGroup()));
      },
      ),
    ));
  }
}
