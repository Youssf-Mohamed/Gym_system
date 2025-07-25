import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/bloc/cubit.dart';
import 'package:gym/bloc/states.dart';

import '../shared/components.dart';

class AddPlanScreen extends StatelessWidget {
  const AddPlanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var nameController =TextEditingController();
    var descriptionController =TextEditingController();
    var priceController =TextEditingController();
    var discountController =TextEditingController();
    var durationController =TextEditingController();
    var attendanceController =TextEditingController();
    var invitationController =TextEditingController();
    final _formKey=GlobalKey<FormState>();
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {

        },
      builder: (context, state) {
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 1,
                  color: Color.fromRGBO(38, 38, 38, 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 200),
                  child: Form(
                    key: _formKey,
                    child: Column(
            
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('New Subscription Plan',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        const Text('Plan Name',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,),
                        Container(
                          width: 500,
                          child: TextFormField(
                            maxLines: 1,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
            
                              ),
                              enabledBorder: OutlineInputBorder(
                              ),
                              focusedBorder: OutlineInputBorder(
                              ),
                              hintText: 'Enter plan name',
                            ),
                            controller: nameController,
                            validator: (value) {
                              if(value!.isEmpty||value==null)
                              {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20,),
                        const Text('Description',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,),
                        Container(
                          height: 200,
                          width: 500,
                          child: TextFormField(
                            maxLines: 100,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
            
                              ),
                              enabledBorder: OutlineInputBorder(
                              ),
                              focusedBorder: OutlineInputBorder(
                              ),
                              hintText: 'Enter plan description',
                            ),
                            controller: descriptionController,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Price',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                                SizedBox(height: 10,),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
            
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                      ),
                                      hintText: 'Enter price',
                                      prefixText: '\$ ' ,
                                    ),
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if(value!.isEmpty||value==null)
                                      {
                                        return 'Please enter a valid price';
                                      }
            
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Discount',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                                SizedBox(height: 10,),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
            
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                        ),
                                        hintText: 'Enter discount',
                                        prefixText: '% ' ,
                                    ),
                                    controller: discountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Duration',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                                SizedBox(height: 10,),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                      ),
                                      hintText: 'Enter duration',
                                      prefixText: 'Day: ' ,
                                    ),
                                    controller: durationController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if(value!.isEmpty||value==null)
                                      {
                                        return 'Please enter a valid duration';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Attendance',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                                SizedBox(height: 10,),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
            
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                      ),
                                        hintText: 'Enter attendance'
                                    ),
                                    controller: attendanceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        const Text('Number of Invitations',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,),
                        Container(
                          width: 500,
                          child: TextFormField(
                            maxLines: 1,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
            
                              ),
                              enabledBorder: OutlineInputBorder(
                              ),
                              focusedBorder: OutlineInputBorder(
                              ),
                              hintText: 'Enter number of invitations',
                            ),
                            controller: invitationController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                          BVButton(childWidget: Text('Create Plan',style: TextStyle(color: Colors.white),),onPressed: ()async{
                            if(_formKey.currentState!.validate())
                            {
                             await cubit.addPlan(
                                name: nameController.text,
                                description: descriptionController.text,
                                days: attendanceController.text.isEmpty?0: int.parse(attendanceController.text),
                                duration: durationController.text.isEmpty?0:int.parse( durationController.text),
                                invitation:invitationController.text.isEmpty?0:int.parse( invitationController.text),
                                price:priceController.text.isEmpty?0:int.parse( priceController.text),
                                discount:discountController.text.isEmpty?0:int.parse( discountController.text),
                              ).then((value){
                                Navigator.pop(context);
                             });
                            }
                          },widthsize: 150),
                        ],)
                      ],
                    ),
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
