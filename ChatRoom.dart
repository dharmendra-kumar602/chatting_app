import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class ChatRoom extends StatelessWidget {

  final Map<String, dynamic> userMap;
  final String ChatRoomId;

  ChatRoom({required this.ChatRoomId, required this.userMap, super.key});

  TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;
  File? videoFile;
  int status = 1;

  Future getImages() async {
    try {
      ImagePicker _picker = ImagePicker();
      await _picker.pickImage(source: ImageSource.gallery).then((xfile) {
        if (xfile != null) {
          imageFile = File(xfile.path);
          print('image picker successfully:${imageFile}');
          uploadImage();
        } else {
          print('image picker failed');
        }
      });
    } catch (e) {
      print('get Images function ::${e}');
      if (e is FirebaseException && e.code == 'canceled') {
        print('Upload canceled by user');
      }
    }
  }

  Future getVideo() async {
    try {
      ImagePicker _picker = ImagePicker();
      await _picker.pickMultipleMedia();
    } catch (e) {
      print('get videoFile function ::${e}');
      if (e is FirebaseException && e.code == 'canceled') {
        print('Upload canceled by user');
      }
    }
  }

  Future uploadImage() async {
    try {
      String fileName = const Uuid().v1();
      await _firestore.collection('chatroom').doc(ChatRoomId).collection(
          'chats').doc(fileName).set({
        "sendBy": _auth.currentUser?.displayName,
        "message": "",
        "type": 'img',
        "time": FieldValue.serverTimestamp(),
      });
      var ref = FirebaseStorage.instance.ref().child('images').child(
          '$fileName.jpg');
      var uploadTask = await ref.putFile(imageFile!).catchError((Error) async {
        await _firestore.collection('chatroom').doc(ChatRoomId).collection(
            'chats').doc(fileName).delete();
        status = 0;
      });

      if (status == 1) {
        String imageUrl = await uploadTask.ref.getDownloadURL();
        await _firestore.collection('chatroom').doc(ChatRoomId).collection(
            'chats').doc(fileName).update({
          "message": imageUrl,

        });
        print('imageUrl:${imageUrl}');
      }
    } catch (e) {
      print('exceptionDk:${e}');
      if (e is FirebaseException && e.code == 'canceled') {
        print('Upload canceled by user');
      }
    }
  }

  Future<void> uploadVideo(File videoFile) async {
    try {
      String fileName = basename(videoFile.path);
      Reference storageReference = FirebaseStorage.instance.ref().child('videos/$fileName');
      UploadTask uploadTask = storageReference.putFile(videoFile);
      await uploadTask.whenComplete(() => print('Video uploaded successfully'));
    } catch (e) {
      print('Error uploading video: $e');
    }
  }

  void onSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "sendBy": _auth.currentUser?.displayName,
        "message": _messageController.text.toString(),
        "type": 'text',
        "time": FieldValue.serverTimestamp(),
      };
      await _firestore.collection('chatroom').doc(ChatRoomId).collection(
          'chats').add(message);
      _messageController.clear();
    } else {
      print('field text required');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users')
              .doc(userMap['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {

              return Container(
                height: 30,
                width: double.infinity,
                child: Row(
                  children: [
                    Text(userMap['name']),
                    // Text(snapshot.data!['name'],
                    //   style: const TextStyle(fontSize: 14),),
                  ],
                ),
              );
            } else {
              return Container(
              );
            }
          },
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 400,
          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('chatroom')
                .doc(ChatRoomId)
                .collection('chats')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data != null) {
                return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic>? map = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>?;
                      // return Text(snapshot.data?.docs[index]['message'],style: const TextStyle(color: Colors.red,fontSize: 20),);
                      return messagess(map!,context);
                    }
                );
              } else {
                return Container(
                  height: 200,
                  width: 400,
                  color: Colors.grey,
                  child: Text('not vailable message'),
                );
              }
            },
          ),
        ),
      ),
      bottomSheet: SingleChildScrollView(
        child: Container(
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
                            //  getImages();
                              getVideo();
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
                    onSendMessage();
                  }, icon: Icon(Icons.send),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget messagess(Map<String, dynamic> map,BuildContext context) {
    return map['type'] == 'text' ? Container(
      width: 300,
      alignment: map['sendBy'] == _auth.currentUser?.displayName ? Alignment
          .centerRight : Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Text(map['message'], style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
      ),
    ) : Container(
      height: 200,
      width: 200,
      alignment: map['sendBy'] == _auth.currentUser!.displayName ? Alignment
          .centerRight : Alignment.centerLeft,
      child: InkWell(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) =>ShowImage(imageUrl: map['message'],)));
        },
        child: Container(
          height: 150,
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all()
          ),
          alignment: map['message'] != '' ? null : Alignment.center,
          child: map['message'] != ''
              ? Image.network(map['message'],fit: BoxFit.cover,)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

}

class ShowImage extends StatelessWidget {

  final String imageUrl;
  const ShowImage({required this.imageUrl,super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height:size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl,fit: BoxFit.cover,),
      ),
    );
  }
}
