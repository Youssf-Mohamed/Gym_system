import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:toastification/toastification.dart';

import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../shared/components.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var _attendController=TextEditingController();
    var _focusNode=FocusNode();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddAttendFailedState){
          toastification.show(
            context: context, // optional if you use ToastificationWrapper
            backgroundColor: Colors.orangeAccent,
            title: Text("${state.error}",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }else if (state is CheckAttendFailedState){
          toastification.show(
            context: context, // optional if you use ToastificationWrapper
            backgroundColor: Colors.orangeAccent,
            title: Text("${state.error}",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }
      },
      builder: (context, state) {
        var cubit=AppCubit.get(context);
        return Column(
          children: [
            // ... (Your Row and TextFormField widgets remain the same)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Attendance',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(height: 15,),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search,),
                hintText: "Scan The ID to Take attendance",
              ),
              controller: _attendController,
              focusNode: _focusNode,
              onFieldSubmitted: (value) async{
                try{
                  await cubit.checkAttend(user: value);
                  if(cubit.checkedRecord.isEmpty){
                      toastification.show(
                        context: context, // optional if you use ToastificationWrapper
                        backgroundColor: Colors.red,
                        title: Text("Please renew subscription",style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
                        autoCloseDuration: const Duration(seconds: 5),
                      );
                  }else{
                      cubit.addAttend(user: value);
                  }
                }
                catch (error)
                {
                  print(error.toString());
                    toastification.show(
                      context: context, // optional if you use ToastificationWrapper
                      backgroundColor: Colors.orangeAccent,
                      title: Text("${error.toString()}",style: TextStyle(color: Colors.white),),
                      icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                }
                _attendController.text="";
                _focusNode.requestFocus();
                print(value);
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Padding(padding: EdgeInsets.all(10), child: Text('Name',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('ID',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Date',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Time',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Days Left',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white60,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cubit.attend.length,
                        itemBuilder: (context, index) {
                          RecordModel _attend=cubit.attend[index];
                          List<RecordModel>? _user=_attend.expand['user'];
                          int hours;
                          String date;
                          print(_attend);
                          (date,hours) = stringToDate(date: _attend.created);
                          return Column(
                            children:[ Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsets.all(10), child: Text('${_user![0].getDataValue('name')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${_attend.getDataValue('user')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${date}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${hours>12?(hours%12).toString()+' PM':hours.toString()+" AM"}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${_attend.getDataValue('days')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
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
