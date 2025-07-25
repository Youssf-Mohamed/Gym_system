import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/const.dart';
import 'package:toastification/toastification.dart';
import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../shared/components.dart';
import 'attendance_screen.dart';
import 'members_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetAttendFailedState){
          toastification.show(
            context: context, // optional if you use ToastificationWrapper
            backgroundColor: Colors.redAccent,
            title: Text("${state.error}",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
            autoCloseDuration: const Duration(seconds: 5),
          );
        } else if(state is GetUsersFailedState){
          toastification.show(
            context: context, // optional if you use ToastificationWrapper
            backgroundColor: Colors.redAccent,
            title: Text("${state.error}",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }else if(state is AddPlanFailedState){
          toastification.show(
            context: context, // optional if you use ToastificationWrapper
            backgroundColor: Colors.redAccent,
            title: Text("${state.error}",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }
        if(state is AddPlanSuccessfulState)
          {
            toastification.show(
              context: context, // optional if you use ToastificationWrapper
              backgroundColor: Colors.green,
              title: Text("Plan added Successful",style: TextStyle(color: Colors.white),),
              icon: Icon(Icons.check,color: Colors.white.withAlpha(200),),
              autoCloseDuration: const Duration(seconds: 5),
            );
          }

      },
      builder: (context, state) {
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10,left: 20),
              child: CircleAvatar(backgroundColor: Colors.white,),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('FitTrack',style: TextStyle(color: Colors.white,fontSize: 20),),
            ),
          ),
          body: Column(
            children: [
              const Divider(
                height: 1,
                color: Color.fromRGBO(38, 38, 38, 1),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                                      
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VDrawerButton(text: 'Dashboard',icon: Icons.home_filled,onPressed: (){
                                    cubit.changeScreen(index: 0);
                                  }),
                                  VDrawerButton(text: 'Attendance',icon: Icons.calendar_month_rounded,onPressed: (){
                                    cubit.changeScreen(index: 1);
                                    cubit.getAttend();
                                  }),
                                  VDrawerButton(text: 'Members',icon: Icons.people,onPressed: (){
                                    cubit.changeScreen(index: 2);
                                    cubit.getUsers();
                                  }),
                                  VDrawerButton(text: 'Products',icon: Icons.lock,onPressed: (){}),
                                  VDrawerButton(text: 'Plans',icon: Icons.add_box,onPressed: (){
                                    cubit.getSubscriptions();
                                    cubit.changeScreen(index: 3);
                                  }),
                                                      
                                ],
                              ),
                            ),
                            Text('This is ${onlineMode?"online version":"offline version"}',style: TextStyle(color: Colors.white60),)
                          ],
                        ),
                      ),
                    ),
                     Expanded(
                      flex: 10,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: cubit.screens[cubit.screenIndex],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}