import 'package:flutter/material.dart';

import '../shared/components.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reports',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        const Text('  OverView',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
        Expanded(
          flex: 2,
          child: Row(children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: dataContainer(title: 'Total Income (Today)',text: '\$${12000}'),
            )),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: dataContainer(title: 'Active Members',text: '${255}'),
            )),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: dataContainer(title: 'Expiring MemberShips',text: '${20}'),
            )),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: dataContainer(title: 'Pending Payments',text: '\$${280}'),
            )),
          ],),
        ),
        const Text('  Income',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
        barChart(data: [8000,10000,16000,15500,18000,11000,21000],labels: ['Jan','Fab','Mar',"Apr","May","Jun","Jul"],title: 'Monthly Income Chart',number: "\$${21000}",subtext: 'This Month'),
        const Text('  Growth',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
        barChart(data: [5,20,10,20,10,60,100],labels: ['Jan','Fab','Mar',"Apr","May","Jun","Jul"],title: 'New Members',number: 100,subtext: 'Last 30 Day'),
      ],
    );
  }
}
