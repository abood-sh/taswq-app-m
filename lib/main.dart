import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tik_laen_taswaq2/models/today_orders.dart';
import 'package:tik_laen_taswaq2/modules/login/cubit/states.dart';
import 'package:tik_laen_taswaq2/modules/splash_screen.dart';
import 'package:tik_laen_taswaq2/shared/bloc_observer.dart';
import 'package:tik_laen_taswaq2/shared/components/constants.dart';
import 'package:tik_laen_taswaq2/shared/cubit/cubit.dart';
import 'package:tik_laen_taswaq2/shared/cubit/states.dart';
import 'package:tik_laen_taswaq2/shared/network/local/cache_helper.dart';
import 'package:tik_laen_taswaq2/shared/network/remote/dio_helper.dart';
import 'package:wakelock/wakelock.dart';

import 'layout/cubit/cubit.dart';
import 'modules/billing/bill_screen.dart';
import 'layout/bottom_home_screen.dart';
import 'modules/goAddress_screen.dart';
import 'modules/home_screen/home_screen.dart';
import 'modules/login/cubit/cubit.dart';
import 'modules/login/login_screen.dart';
import 'modules/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget? widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  if (onBoarding != null) {
    if (token != null)
      widget = BottomHomeScreen();
    else
      widget = LoginScreen();
  } else {
    widget = SplashScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getTodayOrder()
            ..getBalance()..getProfile(),
        ),
        BlocProvider<ShopLoginCubit>(
          create: (BuildContext context) => ShopLoginCubit(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: startWidget,
            //  home: LoginScreen(),
            // home: WelcomeScreen(),
          );
        },
      ),
    );
  }
}
