import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tik_laen_taswaq2/layout/cubit/cubit.dart';
import 'package:tik_laen_taswaq2/models/today_orders.dart';
import 'package:tik_laen_taswaq2/modules/home_screen/NotificationDialog.dart';
import 'package:tik_laen_taswaq2/modules/home_screen/alert_dialog.dart';
import 'package:tik_laen_taswaq2/shared/components/constants.dart';
import 'package:tik_laen_taswaq2/shared/network/local/cache_helper.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future initialize(context, Order order) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
      retrieveRideRequestInfo(getRideRequestId(message.data),context);
      //retrieveRideRequestInfo(order,context);
     // retrieveRideRequestInfo(getRideRequestId(message.data), context);
    });

    firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      print('getInitialMessage data: ${message?.data}');
      retrieveRideRequestInfo(getRideRequestId(message!.data),context);
       //retrieveRideRequestInfo(order,context);
     // retrieveRideRequestInfo(getRideRequestId(message!.data), context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('onMessageOpenedApp data: ${message.data}');
      //retrieveRideRequestInfo(order,context);
      retrieveRideRequestInfo(getRideRequestId(message.data), context);
    });
  }

  String rideRequestId = '';

  String getRideRequestId(Map<String, dynamic> message) {
    /*if (Platform.isAndroid) {
       rideRequestId = message['data'];
     // rideRequestId = message['ride_request_id'];
    } else {
      rideRequestId = message['data'];
     // rideRequestId = message['ride_request_id'];
    }*/
    return rideRequestId;
  }

  void retrieveRideRequestInfo(String? text, BuildContext context) {
    if (text != null) {
      assetsAudioPlayer.open(Audio("assets/sounds/alert.mp3"));
      assetsAudioPlayer.play();

      Order? order = Order();
     // order.id = ShopCubit.get(context).todayOrders!.order['id'] as int;
     // order.toId?.name = 'hassan';
      //order = ShopCubit.get(context).todayOrders!.order as Order?;


      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
       // builder: (BuildContext context) => NotificationDialog(order: order),
        builder: (BuildContext context) => AlertDialogHome(order: order),
      );
    }

  }


}
