import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:toastification/toastification.dart';

import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../shared/components.dart';

class UserSubscriptionsScreen extends StatelessWidget {
  UserSubscriptionsScreen({required this.user, super.key});
  RecordModel user;
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
        if (state is AddSubscriberFailedState){
          toastification.show(
            context: context, // optional if you use ToastificationWrapper
            backgroundColor: Colors.redAccent,
            title: Text("${state.error}",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.error_outline,color: Colors.white.withAlpha(200),),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }
      },
      builder: (context, state) {
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ... (Your Row and TextFormField widgets remain the same)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subscription History',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        VButton(
                          text: 'Subscribe',
                          onPressed: () async{
                            await cubit.getSubscriptions();
                            var dateController=TextEditingController();
                            dateController.text=DateTime.now().toString();
                            bool paid=true;
                            final _formKey = GlobalKey<FormState>();
                            RecordModel? selectedPlan; // local only
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Subscribe',style: TextStyle(color: Colors.white),),
                                  content: Form(
                                    key: _formKey,
                                    child: BlocBuilder<AppCubit, AppStates>(
                                      builder: (context, state) {
                                        var cubit=AppCubit.get(context);
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  DropdownButtonFormField<RecordModel>(
                                                    value: selectedPlan,
                                                    dropdownColor: Colors.black,
                                                    hint: Text("Select a Plan",style: TextStyle(color: Colors.white60,fontWeight: FontWeight.w400),),
                                                    items: cubit.plans.map((plan) {
                                                      return DropdownMenuItem<RecordModel>(
                                                        value: plan,
                                                        child: Text(plan.getDataValue('name').toString(),style: TextStyle(color: Colors.white),),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedPlan = value;
                                                      });
                                                    },
                                                    validator: (value) =>
                                                    value == null ? 'Please select a plan' : null,
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Theme(
                                                    data: Theme.of(context).copyWith(
                                                      colorScheme: ColorScheme.dark(
                                                        primary: Colors.white,       // Header background & selected date
                                                        onPrimary: Colors.white,    // Header text
                                                        surface: Colors.black,      // Background
                                                        onSurface: Colors.white,    // Main text
                                                      ),
                                                      textTheme: const TextTheme(
                                                        bodyMedium: TextStyle(color: Colors.white),  // Input text
                                                      ),
                                                      inputDecorationTheme: const InputDecorationTheme(
                                                        labelStyle: TextStyle(color: Colors.white),
                                                        hintStyle: TextStyle(color: Colors.white70),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.white12),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.white12),
                                                        ),
                                                      ),
                                                      textSelectionTheme: const TextSelectionThemeData(
                                                        cursorColor: Colors.white,               // <-- Cursor color
                                                        selectionColor: Colors.white38,      // <-- Highlighted text bg
                                                        selectionHandleColor: Colors.white,      // <-- Handle dots
                                                      ),
                                                    ),
                                                    child: InputDatePickerFormField(
                                                      fieldLabelText: 'Starting Date',
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now().add(Duration(days: 365)),
                                                      onDateSaved: (value) {
                                                        dateController.text=value.toString();
                                                        print(dateController.text);
                                                      },
                                                      onDateSubmitted: (value) {
                                                        dateController.text=value.toString();
                                                        print(dateController.text);
                                                      },
                                                    ),
                                                  ),
                                                  Row(mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text("Paid",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
                                                    Checkbox(value: paid, onChanged: (value) {
                                                      setState(
                                                              (){
                                                            paid=!paid;
                                                          }
                                                      );
                                                    },
                                                    activeColor: Colors.black,
                                                    )
                                                  ],),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    VButton(text: 'Submit', onPressed: () async{
                                      print(dateController.text);
                                      if (_formKey.currentState!.validate()){
                                        await cubit.addSubscriber(
                                          user: user,
                                          plan: selectedPlan,
                                          days: selectedPlan!.getDataValue('days'),
                                          invitations: selectedPlan!.getDataValue('invitation'),
                                          paid: paid,
                                          startDate: (DateTime.parse(dateController.text).toUtc()).toString(),
                                          endDate: ((DateTime.parse(dateController.text).add(Duration(days: selectedPlan!.getDataValue("duration")))).toUtc()).toString(),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },centered: true),
                                    VButton(text: 'Cancel', onPressed: () => Navigator.pop(context),centered: true)
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        ConditionalBuilder(
                            condition: cubit.subscribers.length>=1,
                            builder: (context) => VButton(text: 'Renew',onPressed: (){}),
                            fallback: null
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                // TextFormField(
                //   style: const TextStyle(color: Colors.white),
                //   cursorColor: Colors.white,
                //   decoration: const InputDecoration(
                //     prefixIcon: Icon(Icons.search,),
                //     hintText: "Search by ID Or Phone",
                //   ),
                //   onChanged: (value) {
                //     value.isEmpty?cubit.getUsers():cubit.getUsers(searchFilter: '(phone~"$value" || id~"$value")');
                //   },
                // ),
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
                              Expanded(child: Padding(padding: EdgeInsets.all(10), child: Text('Plan',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                              Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Start',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                              Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('End',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                              Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Days Left',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                              Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Due',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                              Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('Invitation',style: TextStyle(color: Colors.white,fontSize: 15),),)),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.white60,),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cubit.subscribers.length,
                            itemBuilder: (context, index) {
                              RecordModel subscriber=cubit.subscribers[index];
                              List<RecordModel>? subscription=subscriber.expand['plan'];
                              DateTime startTime=DateTime.parse(subscriber.getDataValue('start_date')).toLocal();
                              String name = subscription![0].getDataValue('name');
                              double price= subscription[0].getDataValue('price');
                              DateTime endTime=DateTime.parse(subscriber.getDataValue('end_date')).toLocal();
                              return Column(
                                children:[ Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Padding(padding: EdgeInsets.all(10), child: Text('$name',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${startTime.year}-${startTime.month}-${startTime.day}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${endTime.year}-${endTime.month}-${endTime.day}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${subscriber.getDataValue('days')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('\$${subscriber.getDataValue('not_paid')?price:'0'}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Text('${subscriber.getDataValue('Invitations')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
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
            ),
          ),
        );
      },
    );
  }
}
