import 'package:firebase/chattingApp/LoginScreen.dart';
import 'package:firebase/chattingApp/methods.dart';
import 'package:flutter/material.dart';
class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  TextEditingController userNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  bool isLoading =  false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child:  isLoading ? Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.red,
            child: const CircularProgressIndicator(),
          ),
        ) : SingleChildScrollView(
          child: Column(
            children: [
             const SizedBox(height: 20,),
              field('User Name',Icons.person,userNameController),
              const SizedBox(height: 20,),
              field('Email',Icons.email,emailController),
              const SizedBox(height: 20,),
              fieldPassword('Password',Icons.remove_red_eye,passwordController),
              const SizedBox(height: 20,),
              actionButton('Create Account'),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: const Text('Login ',style: TextStyle(color: Colors.deepPurpleAccent),),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget field(String hintText,IconData iconName,TextEditingController commonController){
    return TextField(
      controller: commonController,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(iconName),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
      ),
    );
  }

  Widget fieldPassword(String hintText,IconData iconName,TextEditingController commonController){
    return TextField(
      obscureText: true,
      controller: commonController,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(iconName),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
      ),
    );
  }

  Widget actionButton(String buttonTitle){
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

          if(userNameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
            setState(() {
              isLoading = true;
            });
            createAccount(userNameController.text, emailController.text, passwordController.text).then((user) {

              if(user !=null){
                setState(() {
                  isLoading = false;

                });
                print('Account created is successfull');
              }else{
                print('Account created failed');

              }
            });
          }else{

            print("Please fill all details");
          }

          print(buttonTitle);
        },
      ),
    );
  }


}
