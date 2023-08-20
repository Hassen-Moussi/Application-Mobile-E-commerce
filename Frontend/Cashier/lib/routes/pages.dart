import 'package:banking_app/ShopOwner/ShopownerScreen/CashierManager.dart';
import 'package:banking_app/routes/routes.dart';
import 'package:banking_app/screens/ForgotpasswordScreens/CreatePasswordScreen.dart';
import 'package:banking_app/screens/ForgotpasswordScreens/OTPScreen.dart';
import 'package:banking_app/screens/ForgotpasswordScreens/PasswordCreatedScreen.dart';
import 'package:banking_app/screens/Settings/SettingScreen.dart';
import 'package:banking_app/screens/WelcomeScreens/home.dart';
import 'package:banking_app/screens/ProfileManagementScreens/login.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../Connection/No_Connection.dart';
import '../ShopOwner/ShopownerScreen/ChangePassword.dart';
import '../ShopOwner/ShopownerScreen/Home.dart';
import '../ShopOwner/ShopownerScreen/ListCashier.dart';
import '../ShopOwner/ShopownerScreen/NewCashier.dart';
import '../ShopOwner/ShopownerScreen/emailValidator.dart';
import '../screens/ForgotpasswordScreens/forgotpassword.dart';
import '../screens/Onboarding_content/Onboarding_screen.dart';
import '../screens/ProfileManagementScreens/ProfileScreen.dart';
import '../screens/Settings/ChangePassword.dart';
import '../screens/Settings/changeUsername.dart';
import '../screens/Transactions/Balance_History_Page.dart';

class Cpages{
  static List <GetPage> getPages=[
    // GetPage(name: Croutes.initialRoute,
    //     page: (() => Splash())),
    // GetPage(name: Croutes.phone,
    //     page: (() => MyPhone())),
    // GetPage(name: Croutes.verify,
    //     page: (() => MyVerify())),
    // GetPage(name: Croutes.welcome,
    //     page: (() => Welcome())),
    // GetPage(name: Croutes.register,
    //     page: (() => MyRegister())),
    // GetPage(name: Croutes.submit,
    //     page: (() => Submit())),
     GetPage(name: Croutes.profile,
         page: (() => Profile())),
    GetPage(name: Croutes.login,
        page: (() => LoginScreen())),
      // GetPage(name: Croutes.profile,
      //     page: (() => ProfilePage())),
    GetPage(name: Croutes.home,
        page: (() => HomePage())),
    GetPage(name: Croutes.Pcreated,
        page: (() => PasswordCreatedScreen())),
    GetPage(name: Croutes.Cpassword,
        page: (() => CreatePasswordScreen())),
    GetPage(name: Croutes.otp,
        page: (() => OTPScreen())),
    GetPage(name: Croutes.forgotP,
        page: (() => ForgotPasswordScreen())),
    GetPage(name: Croutes.setting,
        page: (() => SettingsScreen())),
    GetPage(name: Croutes.changeP,
        page: (() => ChangePassword())),
    GetPage(name: Croutes.update,
        page: (() => UpdateProfile())),
    GetPage(name: Croutes.NC,
        page: (() => NoConnection())),
    GetPage(name: Croutes.shopowner,
        page: (() => ShopownerHomePage())),
    GetPage(name: Croutes.contact,
        page: (() => ListUser())),
    GetPage(name: Croutes.cashierbalancehistory,
        page: (() => CashierBalanceHistoryPage())),
    GetPage(name: Croutes.tomail,
        page: (() => ToEmail())),
    GetPage(name: Croutes.newcashier,
        page: (() => NewCashier())),
    GetPage(name: Croutes.usermanager,
        page: (() => UserManager())),
    GetPage(name: Croutes.shopownerchangepd,
        page: (() => ShopownerChangePassword())),
    GetPage(name: Croutes.onboarding,
        page: (() => Onbording())),



  ];
}