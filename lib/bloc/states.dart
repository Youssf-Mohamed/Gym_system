abstract class AppStates{}

class AppInitialState extends AppStates{
  
}

class ChangeScreenState extends AppStates{}
class LoginState extends AppStates{}
class LoginSuccessfulState extends AppStates{}
class LoginFailedState extends AppStates{
  LoginFailedState(this.error);
  String error;
}
class GetUsersState extends AppStates{}
class GetUsersSuccessfulState extends AppStates{}
class GetUsersFailedState extends AppStates{
  GetUsersFailedState(this.error);
  String error;
}

class AddAttendState extends AppStates{}
class AddAttendSuccessfulState extends AppStates{}
class AddAttendFailedState extends AppStates{
  AddAttendFailedState(this.error);
  String error;
}

class GetAttendState extends AppStates{}
class GetAttendSuccessfulState extends AppStates{}
class GetAttendFailedState extends AppStates{
  GetAttendFailedState(this.error);
  String error;
}

class AddPlanState extends AppStates{}
class AddPlanSuccessfulState extends AppStates{}
class AddPlanFailedState extends AppStates{
  AddPlanFailedState(this.error);
  String error;
}
class GetSubscriptionsState extends AppStates{}
class GetSubscriptionsSuccessfulState extends AppStates{}
class GetSubscriptionsFailedState extends AppStates{
  GetSubscriptionsFailedState(this.error);
  String error;
}
class GetSubscribersState extends AppStates{}
class GetSubscribersSuccessfulState extends AppStates{}
class GetSubscribersFailedState extends AppStates{
  GetSubscribersFailedState(this.error);
  String error;
}

class AddSubscriberState extends AppStates{}
class AddSubscriberSuccessfulState extends AppStates{}
class AddSubscriberFailedState extends AppStates{
  AddSubscriberFailedState(this.error);
  String error;
}
class CheckAttendState extends AppStates{}
class CheckAttendSuccessfulState extends AppStates{}
class CheckAttendFailedState extends AppStates{
 CheckAttendFailedState(this.error);
  String error;
}
class OnChangesState extends AppStates{}

class SystemTest extends AppStates{}