import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_laen_taswaq2/layout/bottom_home_screen.dart';
import 'package:tik_laen_taswaq2/layout/cubit/cubit.dart';
import 'package:tik_laen_taswaq2/layout/cubit/states.dart';
import 'package:tik_laen_taswaq2/models/deliver_order.dart';

import 'package:tik_laen_taswaq2/models/today_orders.dart';
import 'package:tik_laen_taswaq2/modules/billing/bill_screen.dart';
import 'package:tik_laen_taswaq2/modules/home_screen/home_screen.dart';
import 'package:tik_laen_taswaq2/shared/components/components.dart';
import 'package:tik_laen_taswaq2/shared/styles/color.dart';

import '../goAddress_screen.dart';
import 'alert_dialog_request_price.dart';
import 'myAddress_screen.dart';

class Checkbox2Screen extends StatefulWidget {
  Order? order;

  Checkbox2Screen({this.order});

  @override
  _Checkbox2ScreenState createState() => _Checkbox2ScreenState();
}

class _Checkbox2ScreenState extends State<Checkbox2Screen> {
  var paidController2 = TextEditingController();
  late TextEditingController productPriceController;
  int? selectedValue;

  setSelectedRadio(int val) {
    setState(() {
      selectedValue = val;
    });
  }




  @override
  void didChangeDependencies() {
    var arg = ModalRoute.of(context)!.settings.arguments;
    String? paidpp = widget.order?.paidPrice;
    productPriceController.text = paidpp ?? '0';
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    paidController2.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeliverOrder? deliverOrder;

    return BlocConsumer<ShopCubit, ShopStates>(listener: (context, state) {
      if (state is ShopSuccessDeliverOrderState) {
        deliverOrder = ShopCubit.get(context).deliverOrder;

        print('msg ShopSuccessDeliverOrderState');
        print(deliverOrder!.msg);
        if (deliverOrder!.status!) {
          showToast(text: 'تم تاكيد التسليم', state: ToastStates.SUCCESS);
        } else {
          showToast(
              text: '${deliverOrder?.msg ?? ''}', state: ToastStates.ERROR);
        }
        Navigator.pop(context);
        // print(ShopCubit.get(context).deliverOrder!.msg);
        // showToast(text: '${ShopCubit.get(context).deliverOrder!.msg}', state: ToastStates.SUCCESS);
      } else if (state is ShopErrorDeliverOrderState) {
        showToast(text: '${deliverOrder?.msg ?? ''}', state: ToastStates.ERROR);
        //showToast(text: '${ShopCubit.get(context).deliverOrder!.msg}', state: ToastStates.ERROR);

      }
    }, builder: (context, state) {
      // deliverOrder = ShopCubit.get(context).deliverOrder;
      int? price = int.parse(widget.order?.price ?? '0');

      return Container(
        width: double.infinity,
        height: 650,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'فاتورة التسليم',
                    style: TextStyle(fontSize: 20),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 18, left: 18, top: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'NIS',
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 70,
                                  child: TextFormField(
                                    //controller: productPriceController,
                                    controller: productPriceController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter a number';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'سعر النتجات',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: RowTodayOrder2(
                          text1: 'تكلفة التوصيل',
                          numberText: widget.order?.price ?? 0,
                          color2: Colors.black,
                          nisText: ' NIS    ',
                          color: Colors.black,
                        ),
                      ),
                      myDivider(width: 360),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 28, left: 18, top: 10),
                        child: RowTodayOrder2(
                          text1: 'الاجمالي',
                          numberText:
                              '${(int.parse(productPriceController.text)) + price} ',
                          nisText: ' NIS ',
                          color2: defaultColor,
                          color: defaultColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'المبلغ الاجمالي المستلم ',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  /*Text(
                    'المبلغ الذي تم تحصيله من الزبون',
                    style: TextStyle(fontSize: 19, color: Colors.grey),
                  ),*/
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 50, left: 50),
                    child: TextField(
                      enabled: widget.order?.price == null ? false : true,
                      controller: paidController2,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffix: Text(
                          "NIS",
                          style:
                              TextStyle(fontSize: 20, color: Color(0xFF6A6A6A)),
                        ),
                        hintText: "00:00",
                        hintStyle:
                            TextStyle(fontSize: 24, color: Color(0xFF6A6A6A)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFFFC6011),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            // width: 200,
                            child: Text(
                              widget.order?.fromId?.name ?? '-',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF2D2D2D)),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          Container(
                            child: Radio(
                              activeColor: Color(0xFFFC6011),
                              value: 1,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setSelectedRadio(value!);
                              },
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            // width: 200,
                            child: Text(
                              widget.order?.toId?.name ?? '-',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF2D2D2D)),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          Container(
                            child: Radio(
                              activeColor: Color(0xFFFC6011),
                              value: 2,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setSelectedRadio(value!);
                              },
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  defaultButton(
                    width: 330,
                    decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(30)),
                    function: () {
                      if (widget.order?.price == null) {
                        showToast(
                            text: 'يرجى طلب التسعير', state: ToastStates.ERROR);
                        Navigator.pop(context);
                      } else {
                        if (paidController2.text.isNotEmpty) {
                          ShopCubit.get(context).postDeliverOrder(
                            widget.order!.id!,
                            paidController2.text.toString(),
                            widget.order?.remain ?? 'remain',
                            productPriceController.text.toString(),
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomHomeScreen()));
                          showToast(
                              text: 'تم تاكيد التسليم',
                              state: ToastStates.SUCCESS);
                          /* print(
                                  '${deliverOrder!.orderDeliver!.id} ${deliverOrder!.orderDeliver!.remain}');*/
                          /*ShopCubit.get(context).postDeliverOrder(
                                  ShopCubit.get(context).deliverOrder!.orderDeliver!.id!,
                                  paidController2.text.toString(),
                                  ShopCubit.get(context).deliverOrder!.orderDeliver?.remain ?? 'remain');*/
                          print(
                              '${widget.order!.id!}  ${paidController2.text} ${widget.order!.remain ?? 'remain'}');
                        } else {
                          showToast(
                              text: 'يرجى ادخال رقم ',
                              state: ToastStates.ERROR);
                        }
                      }
                    },
                    text: 'تاكيد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 20),
                  (widget.order!.fromAddress == null &&
                          widget.order!.toAddress == null)
                      ? defaultButton(
                          width: 330,
                          decoration: BoxDecoration(
                              color: defaultColor,
                              borderRadius: BorderRadius.circular(30)),
                          function: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BillScreen(
                                          order: widget.order,
                                        )),
                                ModalRoute.withName('/'));
                          },
                          text: 'عليك الرجوع وادخال البيانات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
