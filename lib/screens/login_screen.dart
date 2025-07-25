import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../const.dart';
import '../shared/components.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({this.navigatorKey, super.key});
  var navigatorKey;
  @override
  Widget build(BuildContext context) {
    var cubit=AppCubit.get(context);
    var email=TextEditingController();
    var password=TextEditingController();
    final _formKey=GlobalKey<FormState>();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
        if (state is LoginFailedState){
          toastification.show(
            context: context, // optional if you use ToastificationWrapper
            backgroundColor: Colors.redAccent,
            title: Text("${state.error}",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }
        if (state is LoginSuccessfulState){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Welcome to Gym System",style: TextTheme.of(context).bodySmall,
            ),centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 350,
                    width: 350,
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: 'Email/Username',
                          ),
                          controller: email,
                          validator: (value) {
                            if(value!.isEmpty||value==null)
                            {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: 'Password',
                          ),
                          obscureText: true,
                          controller: password,
                          validator: (value) {
                            if(value!.isEmpty||value==null)
                            {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        BVButton(childWidget: Text('Login',style: TextTheme.of(context).bodySmall?.copyWith(fontSize: 20)),onPressed: () {
                          if(_formKey.currentState!.validate())
                          {
                            cubit.Login(email: email.text, password: password.text);
                          }
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
