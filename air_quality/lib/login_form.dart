import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.formSubmitHandle});
  final Future<void> Function(String email, String password) formSubmitHandle;
  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String _email = '';
  String _password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
              key: _formKey,
              child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 500, maxHeight: 500),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Image(
                            image: AssetImage("assets/app_logo_128.png"),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            onSaved: (emailValue) => setState(() {
                              _email = emailValue ?? '';
                            }),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your email',
                                labelText: "Email"),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some email';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            onSaved: (passwordValue) => setState(() {
                              _password = passwordValue ?? '';
                            }),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your password',
                                labelText: "Password"),
                            obscureText: true,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some email';
                              }
                              return null;
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              widget.formSubmitHandle.call(_email, _password);
                            }
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.primary ??
                                  Colors.blueAccent,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          child: const Text("Iniciar Sesion"),
                        ),
                      )
                    ],
                  )))),
    );
  }
}
