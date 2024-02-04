import 'package:flutter/material.dart';
class CreateGroup extends StatelessWidget {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('created  Group Name'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Enter Group Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                onPressed: (){

                }, child: const Text('Create Group')),
          ],
        ),
      ),
    );
  }
}
