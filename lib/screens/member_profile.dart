import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/bloc/cubit.dart';
import 'package:gym/bloc/states.dart';
import 'package:gym/const.dart';
import 'package:gym/screens/user_subscriptions_screen.dart';
import 'package:gym/shared/components.dart';
import 'package:pocketbase/pocketbase.dart';

class MemberProfile extends StatelessWidget {
  MemberProfile({required this.user});
  RecordModel user;
  @override
  Widget build(BuildContext context) {
    var cubit=AppCubit.get(context);
    DateTime created = DateTime.parse(user.created).toLocal();
    created.toLocal();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Member Profile',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                const Text('Manage member details,subscriptions,attendance,payment',style: TextStyle(color: Colors.white38,fontSize: 15,fontWeight: FontWeight.w600),),
                SizedBox(height: 30,),
                Row(

                  children: [
                    MaterialButton(onPressed: (){},child: Text('Overview',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),),
                    MaterialButton(onPressed: (){
                      cubit.getSubscribers(user: user.id);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserSubscriptionsScreen(user:user),));
                    },child: Text('Subscription',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),),
                    MaterialButton(onPressed: (){},child: Text('Attendance',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),),
                    MaterialButton(onPressed: (){},child: Text('Payment',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),),
                  ],
                ),
                Divider(color: Colors.white38,),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: ClipOval(
                                child: Image(image: NetworkImage(user.getDataValue('profile_pic')==''?'https://i.pinimg.com/474x/81/8a/1b/818a1b89a57c2ee0fb7619b95e11aebd.jpg':onlineMode?"https://drawn-us.pockethost.io/api/files/users/${user.id}/"+user.getDataValue('profile_pic'):"http://127.0.0.1:8090/api/files/users/${user.id}/"+user.getDataValue('profile_pic')))),
                            radius: 80,
                          ),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${user.getDataValue('name')}',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                              Text('Member ID: ${user.id}',style: TextStyle(color: Colors.white38,fontSize: 15,fontWeight: FontWeight.w600),),
                              Text('Joined: ${created.year}-${created.month}-${created.day}',style: TextStyle(color: Colors.white38,fontSize: 15,fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ],
                      ),
                      MaterialButton(
                        color: Color.fromRGBO(54, 54, 54, 1),
                        onPressed: (){},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Edit Profile",style: TextStyle(color:Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text('Contact',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                SizedBox(height: 20,),
                Divider(color: Colors.white38,),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('Phone',style: TextStyle(color: Colors.white38,fontSize: 15,fontWeight: FontWeight.w600),),),
                    Expanded(flex: 3, child: Text('${user.getDataValue('phone')}',style: TextStyle(color: Colors.white,fontSize: 15,),),)
                  ],
                ),
                SizedBox(height: 10,),
                Divider(color: Colors.white38,),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('email',style: TextStyle(color: Colors.white38,fontSize: 15,fontWeight: FontWeight.w600),),),
                    Expanded(flex: 3, child: Text('${user.getDataValue('email')==null?'No Email':user.getDataValue('email')}',style: TextStyle(color: Colors.white,fontSize: 15,),),)
                  ],
                ),
                SizedBox(height: 10,),
                Divider(color: Colors.white38,),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('Address',style: TextStyle(color: Colors.white38,fontSize: 15,fontWeight: FontWeight.w600),),),
                    Expanded(flex: 3, child: Text('${user.getDataValue('address')}',style: TextStyle(color: Colors.white,fontSize: 15,),),)
                  ],
                ),
                SizedBox(height: 50,),
                Text('Note',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
                SizedBox(height: 20,),
                Expanded(child: SingleChildScrollView(child: Container(child: Text(user.getDataValue('note'),style: TextStyle(color: Colors.white,fontSize: 15,),),))),
                SizedBox(height: 10,),
                MaterialButton(
                  color: Color.fromRGBO(54, 54, 54, 1),
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Add Note",style: TextStyle(color:Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
