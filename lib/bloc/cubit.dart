
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/bloc/states.dart';
import 'package:gym/shared/components.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:toastification/toastification.dart';
import '../const.dart';
import '../main.dart';
import '../screens/attendance_screen.dart';
import '../screens/login_screen.dart';
import '../screens/members_screen.dart';
import '../screens/report_screen.dart';
import '../screens/subscription_plans_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int stopType=0;
  final pb = onlineMode?PocketBase('https://drawn-us.pockethost.io'):PocketBase('http://127.0.0.1:8090');
  List screens=[ReportScreen(),AttendanceScreen(),MembersScreen(),SubscriptionPlansScreen()];
  int screenIndex=0;
  var authData;
  var users=[];
  var attend=[];
  var plans=[];
  var subscribers=[];
  var checkedRecord=[];
  void changeScreen({required index}){
    screenIndex=index;
    emit(ChangeScreenState());
  }
  void Login({required email,required password})async{
    emit(LoginState());
     try{
       authData = await pb.collection('users').authWithPassword(
         '$email',
         '$password',
       );
       print(authData);
       emit(LoginSuccessfulState());
     }
     on ClientException catch(error){
        print(error);
        emit(LoginFailedState(error.response['message']));
     }
  }
  void logout(){
    authData=null;
  }
  void getUsers({searchFilter=''})async{
    emit(GetUsersState());
    try{
      users=await pb.collection('users').getFullList(
        sort: '-created',
        filter: 'type = "user"$searchFilter',
      );
      users.isNotEmpty?print(users[0]):null;
      emit(GetUsersSuccessfulState());
    }
    on ClientException catch(error){
      print(error.toString());
      emit(GetUsersFailedState(error.response['message']));
    }
  }
  void addAttend({required user}) async {
    emit(AddAttendState());
    try{
      final record = await pb.collection('users').getOne('$user',
      ); //delete this if not needed
      try{
        var body=<String,dynamic>{
          "attend_id":attendUuid(userId: user),
          "user":user,
          "days":checkedRecord[0].getDataValue('days')-1,
          "branch":branch,
        };
        var record = await pb.collection('attendance').create(body: body,expand: 'user');

        final updateBody = <String, dynamic>{
          "last_attend": DateTime.now().toUtc().toIso8601String(),
        };
        try{
          final updateRecord = await pb.collection('users').update('$user', body: updateBody);
          print("This is update :+$updateRecord");
          attend.insert(0, record);
          print(attend[0]);
          emit(AddAttendSuccessfulState());
        }
        on ClientException catch(error){
          print(error.toString());
        }
      }
      on ClientException catch(error){
        print(error.toString());
        emit(AddAttendFailedState(error.response['message']));
      }
    }
    on ClientException catch(error)
    {
      emit(AddAttendFailedState(error.response['message']));
    }
  }
  void getAttend() async {
    emit(GetAttendState());
    try{
      attend=await pb.collection('attendance').getFullList(
        sort: '-created',
        expand: 'user',
      );
      print(attend);
      emit(GetAttendSuccessfulState());
    }
    on ClientException catch(error){
      print(error.toString());
      emit(GetAttendFailedState(error.response['message']));
    }
  }
  void getSubscribers({required user}) async {
  emit(GetSubscribersState());
  try{
    subscribers = await pb.collection('subscribers').getFullList(
      sort: '-created',
      filter: 'user = "${user}"',
      expand: 'user,plan',
  );
     emit(GetSubscribersSuccessfulState());
  }
  on ClientException catch(error){
      print(error.toString());
      emit(GetSubscribersFailedState(error.response['message']));
  }
  }
  Future<void> addPlan({required name,String description="",required  duration,required price,days,required invitation,int discount=0,}) async {
    emit(AddPlanState());
    try {
      var body = <String, dynamic>{
        "name": name,
        "description": description,
        "price": price,
        'duration': duration,
        "days": days==0? days= duration: days,
        "invitation": invitation,
        "discount": discount,
        "branch": branch
      };
     await  pb.collection("subscription").create(body: body);

     emit(AddPlanSuccessfulState());
  }
  on ClientException catch(error)
  {
  emit(AddPlanFailedState(error.response['message']));
  }
}
  Future<void> getSubscriptions() async {

    emit(GetSubscriptionsState());
    try{
      plans=await pb.collection('subscription').getFullList();
      emit(GetSubscriptionsSuccessfulState());
    }
    on ClientException catch(error){
      print(error.toString());
      emit(GetSubscriptionsFailedState(error.response['message']));
    }

  }
  Future<void> addSubscriber({required user,required plan,required startDate,required paid,required invitations,required days,required endDate})async{
    emit(AddSubscriberState());
    try{
      var record=await pb.collection("subscribers").create(
        body: {
          "user": user.id,
          "plan": plan.id,
          "branch": branch,
          "not_paid": !paid,
          "start_date":startDate,
          "end_date":endDate,
          "Invitations": invitations,
          "days": days,
        }
      );
      getSubscribers(user: user.id);
      emit(AddSubscriberSuccessfulState());
    }
    on ClientException catch(error)
    {
      print(error.toString());
      emit(AddSubscriberFailedState(error.response['message']));
    }
  }


  Future<void> checkAttend({required user}) async {
    emit(CheckAttendState());
    try{
       checkedRecord=await pb.collection('subscribers').getFullList(
        sort: '+created',
        filter: 'end_date >= start_date && days > 0 && end_date > @now && user = "${user}"',
      );
      if(checkedRecord.isEmpty){
        //throw FormatException('Please renew subscription');
        throw ('Please renew subscription');
      }else{
        pb.collection('subscribers').update(checkedRecord[0].id,body: {
          'days':checkedRecord[0].getDataValue('days')-1,
        });
      }
      emit(CheckAttendSuccessfulState());
    }
    on ClientException catch(error){
      print(error.toString());
      emit(CheckAttendFailedState(error.response['message']));
    }
  }
  void onChanges(){
    emit(OnChangesState());
  }
  void doStop() async {
    if(onlineMode==false && stopType!=4){
    RecordModel localDate = await pb.collection("local_data").getOne(
        "123456789012345");

    stopType = await stopSystem(
      savedDate: localDate
          .getDataValue('saved_date')
          .toString()
          .isEmpty ? DateTime.now() : DateTime.parse(
          localDate.getDataValue('saved_date')).toLocal(),
      expiryDate: DateTime
          .parse(localDate.getDataValue('expiry_date'))
          .toLocal(),
      delete_date: localDate.getDataValue('data_delete_date'),
    );
    print('${DateTime.now().toUtc()}');
    if (stopType != 2) {
      await pb.collection("local_data").update("123456789012345", body: {
        "saved_date": DateTime.now().toUtc().toString(),
      });
    }
  }
  }
  void checkSystem({required GlobalKey<NavigatorState> NavigatorKey,})async{
    if(onlineMode==false && stopType!=4)
    {
      doStop();
      print(stopType);
      RecordModel localDate=await pb.collection("local_data").getOne("123456789012345");
      if(stopType>0)
      {
        localDate.getDataValue("database_deleted")? stopType=4:stopType;
        if(stopType==3){
          try{
            final adminData = await pb.admins.authWithPassword(
              'yosf3336660@gmail.com', // The email you use to log in to the Admin UI
              'yosf333666',        // The password for that admin account
            );

            try{
              await pb.collections.delete("attendance");
            }
            catch(error){
              print(error);
            }
            try{
              await pb.collections.delete("subscribers");
            }
            catch(error){
              print(error);
            }
            try{
              await pb.collections.delete("users");
            }
            catch(error){
              print(error);
            }
            try{
              await pb.collections.delete("subscription");
            }
            catch(error){
              print(error);
            }
            await pb.collection("local_data").update("123456789012345",body: {
              "database_deleted":true,
            });
            stopType=4;
          } catch(error){
            print(error.toString());
          }
        }
        print('type > 0');
        if(authData!=null)
        {
          print('Logout');
          logout();
          NavigatorKey.currentState?.pushAndRemoveUntil( MaterialPageRoute(builder: (context) => MyApp(),), (route) => false,);
        }
        emit(OnChangesState());
      }
    };
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      if(onlineMode==false && stopType!=4)
      {
        doStop();
        print(stopType);
        RecordModel localDate=await pb.collection("local_data").getOne("123456789012345");
        if(stopType>0)
        {
          localDate.getDataValue("database_deleted")? stopType=4:stopType;
          if(stopType==3){
            try{
              final adminData = await pb.admins.authWithPassword(
                'yosf3336660@gmail.com', // The email you use to log in to the Admin UI
                'yosf333666',        // The password for that admin account
              );
              try{
                await pb.collections.delete("attendance");
              }
              catch(error){
                print(error);
              }
              try{
                await pb.collections.delete("subscribers");
              }
              catch(error){
                print(error);
              }
              try{
                await pb.collections.delete("users");
              }
              catch(error){
                print(error);
              }
              try{
                await pb.collections.delete("subscription");
              }
              catch(error){
                print(error);
              }
              await pb.collection("local_data").update("123456789012345",body: {
                "database_deleted":true,
              });
              stopType=4;
            } catch(error){
              print(error.toString());
            }
          }
          print('type > 0');
          if(authData!=null)
          {
          print('Logout');
          logout();
          NavigatorKey.currentState?.pushAndRemoveUntil( MaterialPageRoute(builder: (context) => MyApp(),), (route) => false,);
          }
          emit(OnChangesState());
        }
      }
    });
  }
}

