import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../bloc/cubit.dart';
import '../const.dart';
import '../screens/login_screen.dart';

Widget VDrawerButton({required text,required icon,iconcolor=Colors.white,textcolor=Colors.white,required onPressed})=>Padding(
  padding: const EdgeInsets.all(5),
  child: MaterialButton(
    color: Color.fromRGBO(54, 54, 54, 1),
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon,color: iconcolor,),
          SizedBox(width: 10,),
          Text(text,style: TextStyle(color:textcolor),maxLines: 1,overflow: TextOverflow.ellipsis,),
        ],
      ),
    ),
  ),
);

Widget VButton({required text,textcolor=Colors.white,required onPressed,bool centered=false})=>Padding(
  padding: const EdgeInsets.all(5),
  child: MaterialButton(
    color: Color.fromRGBO(54, 54, 54, 1),
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: centered?MainAxisAlignment.center:MainAxisAlignment.start,
        children: [
          Text(text,style: TextStyle(color:textcolor),),
        ],
      ),
    ),
  ),
);

Widget BVButton({required childWidget,required onPressed,double widthsize=double.infinity,})=>Container(
  width: widthsize,
  color: Colors.black,
  child: MaterialButton(onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: childWidget,
    ),
  ),
);



(String,int) stringToDate({required date}){
  DateTime dateTime = DateTime.parse(date!);
  dateTime=dateTime.toLocal();
  String time=("${dateTime.year}-${dateTime.month}-${dateTime.day}");
  print(time);
  return (time,dateTime.hour);
}
bool isActive(String? lastAttend){
  print(lastAttend);
  DateTime dateTimeUtc = DateTime.parse(lastAttend!);
  DateTime toDay=DateTime.now();
  Duration difference=toDay.difference(dateTimeUtc);
  return difference.inDays>=90?false:true;
}

String attendUuid({required userId}){
  var uuid=Uuid();
  var date=DateTime.now();
  String time=("${date.year}-${date.month}-${date.day}");
  String _namespace=namespace;
  String id=userId;
  String idTime="$id-$time";
  var uid=uuid.v5(_namespace, idTime);
  print(uid);
  return uid;
}


Widget barChart({
  required List<double> data,
  List<String>? labels, // Optional parameter for labels
  required title,
  required  number,
  var subtext=''
}) {
  double maxDataValue = 0;
  if (data.isNotEmpty) {
    maxDataValue = data.reduce((curr, next) => curr > next ? curr : next);
  }

  // Define the PREFERRED maximum bar height when there's ample space.
  // We'll dynamically adjust this down if screen real estate is limited.
  final double preferredMaxBarHeight = 150.0;
  final double minBarHeight = 10.0; // Keep a reasonable minimum bar height

  final double horizontalPaddingBetweenBars = 4.0;
  final double labelTextFontSize = 15; // Your original fontSize for labels
  final double labelSizedBoxHeight = 4.0;

  // Approximate total height taken by the label and its spacing.
  // Adding a small buffer (e.g., * 1.2) helps account for actual text rendering height.
  final double approximateLabelFullHeight = labelTextFontSize * 1.2 + labelSizedBoxHeight;

  return Expanded(
    flex: 3,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white12,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15), // Your original padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$number',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$subtext',
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double availableWidth = constraints.maxWidth;
                    final double availableHeightForBarsAndLabels = constraints.maxHeight;

                    // Calculate the maximum bar height based on available vertical space.
                    // This is the total height minus the space for labels.
                    double calculatedMaxBarHeight = availableHeightForBarsAndLabels - approximateLabelFullHeight;

                    // IMPORTANT: Ensure calculatedMaxBarHeight is not negative or too small.
                    // It must at least accommodate the minBarHeight.
                    calculatedMaxBarHeight = calculatedMaxBarHeight.clamp(minBarHeight, double.infinity);

                    // The actual maximum height a bar can reach will be the MINIMUM
                    // of our preferred fixed height and the dynamically calculated one.
                    final double finalMaxBarHeight =
                    calculatedMaxBarHeight < preferredMaxBarHeight
                        ? calculatedMaxBarHeight
                        : preferredMaxBarHeight;


                    final int numberOfBars = data.length;

                    final double totalPaddingWidth = numberOfBars > 0
                        ? (numberOfBars - 1) * horizontalPaddingBetweenBars
                        : 0;

                    final double barWidth = numberOfBars > 0
                        ? (availableWidth - totalPaddingWidth) / numberOfBars
                        : 0;

                    final double actualBarWidth = barWidth.isFinite && barWidth > 0 ? barWidth : 0;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: data.asMap().entries.map((entry) {
                        int index = entry.key;
                        double value = entry.value;

                        double barHeight = 0;
                        if (maxDataValue > 0) {
                          barHeight = (value / maxDataValue) * finalMaxBarHeight;
                        }
                        // Clamp barHeight to be between minBarHeight and the determined finalMaxBarHeight
                        barHeight = barHeight.clamp(minBarHeight, finalMaxBarHeight);

                        String labelText;
                        if (labels != null && index < labels.length) {
                          labelText = labels[index];
                        } else {
                          labelText = value.toInt().toString();
                        }

                      //  final String tooltipMessage = '${labelText}: ${value.toInt()}';
                        final String tooltipMessage = '${value.toInt()}';
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < numberOfBars - 1 ? horizontalPaddingBetweenBars : 0,
                          ),
                          child: Tooltip( // Added Tooltip for hover text
                            message: tooltipMessage,
                            preferBelow: true,
                            textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: barHeight,
                                  width: actualBarWidth,
                                  decoration: BoxDecoration(
                                    color:  Color.fromRGBO(54, 54, 54, 1),
                                    borderRadius: BorderRadius.circular(2),
                                    border: BorderDirectional(top: BorderSide(color: Colors.white12,width: 2)))
                                  ),
                                SizedBox(height: labelSizedBoxHeight),
                                SizedBox(
                                  width: actualBarWidth,
                                  child: Text(
                                    labelText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white70, fontSize: labelTextFontSize, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget dataContainer({required title,required text}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.white12,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${title}',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),maxLines: 2,overflow: TextOverflow.ellipsis,),
          Text('${text}',style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
        ],
      ),
    ),
  );
}



//offline Mode config pocketbase
Process? pocketBaseProcess;

Future<void> startPocketBase() async {
  final executablePath = Platform.resolvedExecutable;
  final appDir = File(executablePath).parent;

  final pbExecutable = File('${appDir.path}/config/pocketbase.exe'); // For Windows
  // For macOS/Linux use './pocketbase'

  if (!pbExecutable.existsSync()) {
    print('PocketBase executable not found!');
    return;
  }

  pocketBaseProcess = await Process.start(
    pbExecutable.path,
    ['serve'],
    runInShell: true,
    workingDirectory: appDir.path,
  );

  // Optional: Listen to output
  pocketBaseProcess!.stdout.transform(SystemEncoding().decoder).listen(print);
  pocketBaseProcess!.stderr.transform(SystemEncoding().decoder).listen(print);
}

Future<void> stopPocketBase() async {
  if (pocketBaseProcess != null) {
    print('Attempting to stop PocketBase process...');
    pocketBaseProcess!.kill();

    // The crucial new line:
    // This PAUSES the function and waits until the process has truly exited.
    await pocketBaseProcess!.exitCode.timeout(const Duration(seconds: 5));

    print('PocketBase process has exited.');
    pocketBaseProcess = null;
  }
}

/// Sets up exit hooks to ensure cleanup happens before the script terminates.
void setupExitHook() {
  // Make the signal handlers async to use 'await'
  ProcessSignal.sigint.watch().listen((_) async { // <--- async here
    print('\nReceived SIGINT (Ctrl+C). Shutting down...');
    await stopPocketBase(); // <--- await here
    exit(0);
  });

  // This is for Linux/macOS, but good practice to keep.
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) async {
      print('Received SIGTERM. Shutting down...');
      await stopPocketBase(); // Wait for shutdown to complete
      exit(0);
    });
  }

  print('Exit hooks set up. Press Ctrl+C to exit gracefully.');
}

int stopSystem({required DateTime? savedDate,required DateTime? expiryDate,int delete_date=14,}) {
  DateTime todayDate=DateTime.now();
  print('${savedDate.toString()} /// ${todayDate.toString()}');
  if(savedDate?.compareTo(todayDate)==1){
    return 2;
  }
  else if (todayDate.compareTo(expiryDate!.add(Duration(minutes: delete_date)))==1)
  {
    return 3;
  }
  else if (todayDate.compareTo(expiryDate!)==1)
    {
      return 1;
    }
  savedDate=todayDate;
  return 0;
}
String stopText({required int type,contact="01140083887 or 01124920955"}){
  if(type==2)
    {
      return "Please set the time to the default setting.";
    }
  else if(type==1){
      return "The free trial has ended. To prevent data loss, please contact: $contact";
  }
  return "The system data has been deleted. To restore your service, please contact: $contact";

}
