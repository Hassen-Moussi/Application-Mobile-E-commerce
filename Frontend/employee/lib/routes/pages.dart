
import 'package:dyno_mvp/Admin/AdminScreen/AdminHome.dart';
import 'package:dyno_mvp/Admin/Cantacte/ListUser.dart';
import 'package:dyno_mvp/routes/routes.dart';
import 'package:dyno_mvp/screens/OTP/Verify.dart';
import 'package:dyno_mvp/screens/Welcome/welcome.dart';
import 'package:dyno_mvp/screens/register_screen/register_submit.dart';
import 'package:dyno_mvp/screens/register_screen/registration.dart';
import 'package:dyno_mvp/screens/splash_screen/splash.dart';
import 'package:get/get.dart';
import '../Admin/AdminScreen/EmployeeManager.dart';
import '../Admin/AdminScreen/emailnavigation.dart';
import '../Admin/AdminScreen/profileAdminScreen/AdminSettingScreen.dart';
import '../Connection/No_Connection.dart';
import '../controllers/MainPage.dart';
import '../controllers/ScanCodeQr.dart';
import '../controllers/paymentpage.dart';
import '../controllers/qrvaluepage.dart';
import '../screens/ChatScreen/Chat.dart';
import '../screens/EmployeeBalanceHistory/BalanceHistory.dart';
import '../screens/Login/LoginScreen.dart';
import '../screens/OTP/Phone.dart';
import '../screens/Onboarding_content/Onboarding_screen.dart';
import '../screens/SearchScreen/SearchPage.dart';

import '../screens/Settings/ChangePassword.dart';
import '../screens/Settings/CreatePasswordScreen.dart';
import '../screens/Settings/OTPScreen.dart';
import '../screens/Settings/PasswordCreatedScreen.dart';
import '../screens/Settings/forgotpassword.dart';
import '../screens/profileScreen/ProfileEmployee.dart';

class Cpages{
  static List <GetPage> getPages=[
    GetPage(name: Croutes.initialRoute,
     page: (() => Splash())),
     GetPage(name: Croutes.phone,
     page: (() => MyPhone())),
     GetPage(name: Croutes.verify,
     page: (() => MyVerify())),
     GetPage(name: Croutes.welcome,
     page: (() => Welcome())),
    GetPage(name: Croutes.register,
        page: (() => MyRegister())),
    GetPage(name: Croutes.submit,
        page: (() => Submit())),
    GetPage(name: Croutes.onboarding,
        page: (() => Onbording())),
    GetPage(name: Croutes.login,
        page: (() => LoginScreen())),
    GetPage(name: Croutes.profile,
        page: (() => Profile())),
    GetPage(name: Croutes.home,
        page: (() => HomePage())),
    GetPage(name: Croutes.qrpage,
        page: (() => QRViewExample())),
    GetPage(name: Croutes.qrval,
        page: (() => MyQrValuePage())),
    GetPage(name: Croutes.payment,
        page: (() => MyPaymentPage())),
    GetPage(name: Croutes.searchpage,
        page: (() => SearchForUsersPage())),
    GetPage(name: Croutes.chatscreen,
        page: (() => ChatScreen(employeeId: '2c694247-cc30-4e46-a05d-6f47cf480133',))),
    GetPage(name: Croutes.otp,
        page: (() => OTPScreen())),
    GetPage(name: Croutes.Pcreated,
        page: (() => PasswordCreatedScreen())),
    GetPage(name: Croutes.Cpassword,
        page: (() => CreatePasswordScreen())),
    GetPage(name: Croutes.changeP,
        page: (() => ChangePassword())),
    GetPage(name: Croutes.forgotP,
        page: (() => ForgotPasswordScreen())),
    GetPage(name: Croutes.NC,
        page: (() => NoConnection())),
    GetPage(name: Croutes.balancehistory,
        page: (() => EmployeeBalanceHistoryPage())),
    GetPage(name: Croutes.AdminSettings,
        page: (() => AdminSettingsScreen())),
    GetPage(name: Croutes.tomail,
        page: (() => ToEmail())),
    GetPage(name: Croutes.EmployerPage,
        page: (() => AdminHomePage())),
    GetPage(name: Croutes.list,
        page: (() => ListUser())),
    GetPage(name: Croutes.usermanager,
        page: (() => UserManager())),
  ];
}