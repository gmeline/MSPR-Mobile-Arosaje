import 'package:flutter/material.dart';
import 'accueil.dart';
import 'utilisateur.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isButtonVisible = false;

  @override
  void initState(){
    super.initState();
    usernameController.addListener(updateButtonVisibility);
    passwordController.addListener(updateButtonVisibility);
  }
  void updateButtonVisibility(){
    setState((){
      isButtonVisible = usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }
  void login(){
    String username = usernameController.text;
    String password = passwordController.text;

    Utilisateur utilisateurTrouve = listeUtilisateurs.firstWhere(
          (utilisateur) => utilisateur.mail == username || utilisateur.pseudo == username,
      orElse: () => Utilisateur(mail: '', pseudo: '', telephone: '', motDePasse: '', type: ''),
    );

    if(utilisateurTrouve != null && utilisateurTrouve.motDePasse == password){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>AccueilPage(type: utilisateurTrouve.type)),
      );
    } else {
      showDialog(
        context:context,
        builder:(context)=>AlertDialog(
          title:Text('Erreur de connexion'),
          content: Text('Identifiant ou mot de passe incorrect.'),
          actions : [
            TextButton(
              onPressed: ()=>Navigator.pop(context),
              child:Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:[
          Colors.brown,
          Colors.green,
        ],
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page(){
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: SingleChildScrollView( // Wrappez la colonne avec SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              _icon(),
              const SizedBox(height:50),
              _inputField("Pseudo/mail ou téléphone", usernameController),
              const SizedBox(height:20),
              _inputField("Mot de passe", passwordController, isPassword: true),
              const SizedBox(height:50),
              _loginBtn(),
              const SizedBox(height:50),
              _extraText(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _icon(){
    return Container(
      decoration:BoxDecoration(
        border:Border.all(color:Colors.white,width:2),
        shape:BoxShape.circle,
      ),
      child: Image.asset(
        'assets/images/logo.png',
        width:120,
        height:120,
        fit:BoxFit.cover,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,{isPassword = false}){
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white)
    );
    return TextField(
      style: const TextStyle(color:Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color:Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText:isPassword,
    );
  }

  Widget _loginBtn(){
    return isButtonVisible ? ElevatedButton(
      onPressed: login, // Utiliser la méthode de vérification des informations de connexion
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Se connecter",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    ) : SizedBox();
  }

  Widget _extraText(){
    return const Text(
      "Vous n'arrivez pas à accéder à votre compte?",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 16,
          color: Colors.white
      ),
    );
  }

}