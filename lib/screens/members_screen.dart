// lib/screens/members_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/shared/components.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:toastification/toastification.dart';

import '../bloc/cubit.dart';
import '../bloc/states.dart';
import 'member_profile.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=AppCubit.get(context);
        return Column(
          children: [
            // ... (Your Row and TextFormField widgets remain the same)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Members',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                VButton(text: 'Add Member',onPressed: (){}),
              ],
            ),
            const SizedBox(height: 15,),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search,),
                hintText: "Search by ID Or Phone",
              ),
              onChanged: (value) {
                value.isEmpty?cubit.getUsers():cubit.getUsers(searchFilter: '(phone~"$value" || id~"$value")');
              },
            ),
            const SizedBox(height: 15,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white60, width: 1),
                ),
                child: Column(
                  children: [
                    // Your header Row container...
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft:  Radius.circular(10),topRight: Radius.circular(10)),
                        color: Color.fromRGBO(50, 50, 50, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.all(10), child: Text('Name',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('ID',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Status',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Days Left',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Total Due',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('Profile (${cubit.users.length})',style: TextStyle(color: Colors.white,fontSize: 15),)),)),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white60,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cubit.users.length,
                        itemBuilder: (context, index) {
                          RecordModel user=cubit.users[index];
                          return Column(
                            children:[ Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsets.all(10), child: GestureDetector(child: Text('${user.getDataValue('name')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),onTap: ()async{
                                  await Clipboard.setData(ClipboardData(text: "${user.getDataValue('name')}"));
                                  toastification.show(
                                    context: context, // optional if you use ToastificationWrapper
                                    backgroundColor: Colors.green,
                                    title: Text("copied to clipboard",style: TextStyle(color: Colors.white),),
                                    icon: Icon(Icons.check,color: Colors.white.withAlpha(200),),
                                    autoCloseDuration: const Duration(seconds: 5),
                                  );
                                  },),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: GestureDetector(child: Text('${user.id}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),onTap:()async{
                                  await Clipboard.setData(ClipboardData(text: "${user.id}"));
                                  toastification.show(
                                    context: context, // optional if you use ToastificationWrapper
                                    backgroundColor: Colors.green,
                                    title: Text("copied to clipboard",style: TextStyle(color: Colors.white),),
                                    icon: Icon(Icons.check,color: Colors.white.withAlpha(200),),
                                    autoCloseDuration: const Duration(seconds: 5),
                                  );
                                },),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${user.getDataValue('last_attend')!=""?(isActive(user.getDataValue('last_attend'))?"Active":"Inactive"):'No attend'}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('30',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('\$${user.getDataValue('due')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: MaterialButton(onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MemberProfile(user: user,),));
                                } ,child: Text("View Profile",style: TextStyle(color: Colors.white),),)),),
                              ],
                            ),
                              const Divider(height: 1, color: Colors.white60,),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}