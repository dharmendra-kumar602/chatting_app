import 'package:firebase/chattingApp/CreateAccount.dart';
import 'package:firebase/chattingApp/methods.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading ? Container(
          height: 50,
          width: 50,
          color: Colors.red,
          child: const Center(child: CircularProgressIndicator(),),
        ): Column(
          children: [
            fieldEmail('email',Icons.email,emailController),
            const SizedBox(height: 10,),
            fieldPassword('password',Icons.remove_red_eye,passwordController),
            const SizedBox(height: 10,),
            actionButton('Login here'),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) =>CreateAccount()));
              },
              child: const Text('Create Account',style: TextStyle(color: Colors.deepPurpleAccent),),
            ),

          ],
        ),
      ),
    );
  }

  Widget fieldEmail(String hintText,IconData iconName,TextEditingController commonController){
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

          if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){

            setState(() {
              isLoading = true;
            });
            login(emailController.text, passwordController.text,context).then((user){

              if(user != null){
                setState(() {
                  isLoading = false;

                });
                print('Login Successfull');

              }else{
                print('Login failed');

              }
            });

          }else{
            print("plz fill all login field");

          }
        },
      ),
    );
  }

}
