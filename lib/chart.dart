import 'package:firebase/const/color_helper.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderStatusChart extends StatefulWidget {
  @override
  State<OrderStatusChart> createState() => _OrderStatusChartState();
}

class _OrderStatusChartState extends State<OrderStatusChart> {

  ShopController shopController=Get.put(ShopController());

   List<OrderStatus> data = [
    OrderStatus('Delivered', 0),
    OrderStatus('Shop Canceled', 0),
    OrderStatus('User Canceled', 0),
    OrderStatus('Pending', 0),
  ];

   int del=0;int pending=0;int ShCancel=0; int uCancel=0;
 @override
  void initState() {
   del=shopController.findOrderStatCount("delivered");
   pending=shopController.findOrderStatCount("accepted");
   uCancel=shopController.findOrderStatCount("userCancel");
   ShCancel=shopController.findOrderStatCount("shopCancel");
   setData();
    super.initState();
  }

  void setData(){
   setState(() {
     data = [
       OrderStatus('Delivered', del),
       OrderStatus('Shop Canceled', ShCancel),
       OrderStatus('User Canceled', uCancel),
       OrderStatus('Pending', pending),
     ];
   });
  }

  @override
  Widget build(BuildContext context) {
    int totalCount = shopController.orderList.length;


    return AspectRatio(
      aspectRatio: 1.3,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: _generateSections(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 1,
              centerSpaceRadius: 45.0,
            ),
          ),
          Center(
            child: Text(
              totalCount.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    List<Color> colors = [
      Colors.green,
      ColorHelper.shopKeeperThemeColor,
      ColorHelper.userThemeColor,
      Colors.amber,
    ];

    List<PieChartSectionData> sections = [];

    for (int i = 0; i < data.length; i++) {
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: data[i].count.toDouble(),
          title: '${data[i].status}\n${data[i].count}',
          radius: 110.0,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }
}

class OrderStatus {
  final String status;
  final int count;

  OrderStatus(this.status, this.count);
}