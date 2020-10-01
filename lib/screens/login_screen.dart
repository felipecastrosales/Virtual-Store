import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          'Entrar',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'CRIAR CONTA',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 18,
              ),
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SignUpScreen())
              );
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(24),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
                      if(text.isEmpty || !text.contains("@")) {
                        return "E-mail inválido";
                      } else {
                        return null;
                      }
                    }
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Senha",
                    ),
                    validator: (text){
                      if(text.isEmpty || text.length < 8){
                        return "A senha deve ter pelo menos 8 caracteres";
                      } else {
                        return null;
                      }
                    }
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      if(_emailController.text.isEmpty)
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Insira seu e-mail para recuperar sua senha.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        )
                        );
                      else {
                        model.recoverPass(_emailController.text);
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Confira seu email',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
                          backgroundColor: Colors.amber,
                          duration: Duration(seconds: 3),
                        )
                        );
                      }
                    },
                    child: Text(
                      "Esqueci minha senha",
                      style: TextStyle(
                          fontFamily: 'Merriweather',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                    child: Text(
                      "ENTRAR",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    color: Colors.amber,
                    onPressed: (){
                      if(_formKey.currentState.validate()){

                      }
                      model.signIn(
                        email: _emailController.text,
                        pass: _passController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Falha ao entrar, veja se seu email e senha estão corretas.',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
        ),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    )
    );
  }
}
