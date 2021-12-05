import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:housemanagement/core/base_colors.dart';
import 'package:housemanagement/core/font_sizes.dart';
import 'package:housemanagement/services/bills_service.dart';

class BillsExpensesScreen extends StatefulWidget {
  const BillsExpensesScreen({Key? key}) : super(key: key);

  @override
  _BillsExpensesScreenState createState() => _BillsExpensesScreenState();
}

class _BillsExpensesScreenState extends State<BillsExpensesScreen> {
  final BillsService _billsService = BillsService();

  List<String> months = <String>[
    "Styczeń",
    "Luty",
    "Marzec",
    "Kwiecień",
    "Maj",
    "Czerwiec",
    "Lipiec",
    "Sierpień",
    "Wrzesień",
    "Październik",
    "Listopad",
    "Grudzień"
  ];

  static const double barWidth = 22;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
            aspectRatio: 1.0,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder(
                    stream:
                        Stream.fromFuture(_billsService.getMonthlyExpenses()),
                    builder:
                        (context, AsyncSnapshot<Map<String, double>> snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return const LoadingElement();
                      // }
                      // if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return SizedBox(
                              width:
                                  100 * snapshot.data!.keys.length.toDouble(),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: BarChart(
                                    BarChartData(
                                        alignment: BarChartAlignment.center,
                                        maxY: snapshot.data!.values
                                            .fold<double>(0, max),
                                        minY: 0,
                                        groupsSpace: 50,
                                        barTouchData: BarTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              barTouchResponse) {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                barTouchResponse == null ||
                                                barTouchResponse.spot == null) {
                                              setState(() {
                                                touchedIndex = -1;
                                              });
                                              return;
                                            }
                                            setState(() {
                                              touchedIndex = barTouchResponse
                                                  .spot!.touchedBarGroupIndex;
                                            });
                                          },
                                          touchTooltipData: BarTouchTooltipData(
                                              tooltipBgColor: Theme.of(context)
                                                  .primaryColor,
                                              getTooltipItem: (
                                                BarChartGroupData group,
                                                int groupIndex,
                                                BarChartRodData rod,
                                                int rodIndex,
                                              ) {
                                                final textStyle = TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: AppFontSizes.normal,
                                                );
                                                return BarTooltipItem(
                                                    rod.y.toString(),
                                                    textStyle);
                                              }),
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          topTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (context, value) =>
                                                TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .color,
                                                    fontSize:
                                                        AppFontSizes.normal),
                                            margin: 20,
                                            rotateAngle: 0,
                                            getTitles: (double value) {
                                              switch (value.toInt()) {
                                                case 0:
                                                  return months[0];
                                                case 1:
                                                  return months[1];
                                                case 2:
                                                  return months[2];
                                                case 3:
                                                  return months[3];
                                                case 4:
                                                  return months[4];
                                                case 5:
                                                  return months[5];
                                                case 6:
                                                  return months[6];
                                                case 7:
                                                  return months[7];
                                                case 8:
                                                  return months[8];
                                                case 9:
                                                  return months[9];
                                                case 10:
                                                  return months[10];
                                                case 11:
                                                  return months[11];
                                                default:
                                                  return '';
                                              }
                                            },
                                          ),
                                          bottomTitles:
                                              SideTitles(showTitles: false),
                                          leftTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (context, value) =>
                                                TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .color,
                                                    fontSize:
                                                        AppFontSizes.small),
                                            rotateAngle: 0,
                                            getTitles: (double value) {
                                              if (value == 0) {
                                                return '0';
                                              }
                                              return '${value.toInt()}';
                                            },
                                            interval: 1500,
                                            margin: 8,
                                            reservedSize: 25,
                                          ),
                                          rightTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (context, value) =>
                                                TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .color,
                                                    fontSize:
                                                        AppFontSizes.small),
                                            rotateAngle: 0,
                                            getTitles: (double value) {
                                              if (value == 0) {
                                                return '0';
                                              }
                                              return '${value.toInt()}';
                                            },
                                            interval: 1500,
                                            margin: 8,
                                            reservedSize: 25,
                                          ),
                                        ),
                                        gridData: FlGridData(
                                          show: true,
                                          checkToShowHorizontalLine: (value) {
                                            return value % 500 == 0;
                                          },
                                          getDrawingHorizontalLine: (value) {
                                            if (value == 0) {
                                              return FlLine(
                                                  color:
                                                      const Color(0xff363753),
                                                  strokeWidth: 3);
                                            }
                                            return FlLine(
                                              color: const Color(0xff2a2747),
                                              strokeWidth: 0.8,
                                            );
                                          },
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        barGroups:
                                            _buildBarGroups(snapshot.data!)),
                                  )));
                        }
                      }
                      // }
                      return const Text(' ');
                    }),
              ),
            )),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, double> monthlyExpenses) {
    var barChartGroupsData = <BarChartGroupData>[];
    for (var i = 0; i < months.length; i++) {
      monthlyExpenses.forEach((key, value) {
        if (i == int.parse(key) - 1) {
          barChartGroupsData.add(BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                y: value,
                width: barWidth,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                rodStackItems: [
                  BarChartRodStackItem(
                      0,
                      value,
                      Theme.of(context).primaryColor,
                      BorderSide(
                          color: AppBaseColors.whiteColor,
                          width: touchedIndex == 3 ? 2 : 0)),
                ],
              ),
            ],
          ));
        }
      });
    }

    return barChartGroupsData;
  }
}
