import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';

import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../shared/components.dart';
import 'add_plan_screen.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

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
                const Text('Subscription Plans',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                VButton(text: 'Add plan',onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPlanScreen(),));
                }),
              ],
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
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('Duration',style: TextStyle(color: Colors.white,fontSize: 15),)),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('Attendance',style: TextStyle(color: Colors.white,fontSize: 15),)),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('Price',style: TextStyle(color: Colors.white,fontSize: 15),)),)),
                          Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('Actions',style: TextStyle(color: Colors.white60,fontSize: 15),)),)),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white60,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cubit.plans.length,
                        itemBuilder: (context, index) {
                          RecordModel plan=cubit.plans[index];
                          return Column(
                            children:[ GestureDetector(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Padding(padding: EdgeInsets.all(10), child: Text('${plan.getDataValue('name')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15),),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('${plan.getDataValue('duration')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white60,fontSize: 15),)),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('${plan.getDataValue('days')}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white60,fontSize: 15),)),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Center(child: Text('\$${plan.getDataValue('price')-(plan.getDataValue('price')*(plan.getDataValue('discount')/100))}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white60,fontSize: 15),)),)),
                                    Expanded(child: Padding(padding: EdgeInsets.all(15), child: Row(
                                      children: [
                                        MaterialButton(onPressed: () {
                                        } ,child: Text("Edit",style: TextStyle(color: Colors.white60),),),
                                        Container(height: 20,color: Colors.white,width: 1,),
                                        MaterialButton(onPressed: () {
                                        } ,child: Text("Delete",style: TextStyle(color: Colors.white60),),),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    )),),
                                  ],
                                ),
                              ),
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
