import 'package:flutter/material.dart';
import 'package:hospital/finance/Expense_charge.dart';
import 'package:hospital/finance/Expense_payment.dart';
import 'package:hospital/finance/Expenses.dart';
import 'package:hospital/finance/Payments.dart';
import 'package:hospital/finance/receipts.dart';
import 'package:hospital/finance/salary_charge.dart';
var list = ['salary Charge','Expense Charge','Expenses','Payment','Receipts','Expense Payment'];
class FinancedashbordScreen extends StatelessWidget {
  const FinancedashbordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Center(child: Text('Finance Dashboard'),),
      ),
      body: Center(
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.blue,
                    child:Center(
                      child: Text('HOSPITAL SYSTEM',
                        style: TextStyle(color: Colors.white,fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('SECTIONS OF MANAGEMENT',
                      style: TextStyle(color: Colors.blue,fontSize: 20,
                          fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 400,
                    child:   Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.white,
                      elevation: CircularProgressIndicator.strokeAlignCenter,

                      child: Padding(

                          padding: EdgeInsets.all(10),
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.7
                              ),
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index,){
                                return GestureDetector(
                                  onTap: () {


                                  },
                                  child: Card(
                                    color: Colors.blue,
                                    child: SizedBox(
                                      height: 50,
                                      width: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(onPressed: (){

                                              if(index==0){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const Salary_chargeScreen()),
                                                );
                                              }else if(index==1){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const Expense_chargeScreen()),
                                                );
                                              }
                                              else if(index==2){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const ExpenseScreen()),
                                                );
                                              }else if(index==3){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const PaymentScreen()),
                                                );
                                              }else if(index==4){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const ReceiptsScreen()),
                                                );
                                              }else if(index==5){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const Expense_payScreen()),
                                                );
                                              }

                                            }, icon:const  Icon(
                                              Icons.currency_exchange_rounded, size:
                                            100,color: Colors.white,)),
                                            Text(list[index],
                                                style: const TextStyle(color: Colors.white,fontSize: 10,
                                                    fontWeight: FontWeight.bold)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );


                              }
                          )
                      ),

                    ),
                  ),

                ],
              ),
            ],
          )
      ),
    );
  }
}
