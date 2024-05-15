import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';

class Prescriptions extends StatelessWidget {
  const Prescriptions({Key? key, required this.patient_id}) : super(key: key);

  final patient_id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: operationsLab.instance.fetch_Data(
          'SELECT * from prescription join patient_table on prescription.v_no=patient_table.p_no where p_no=${patient_id}'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(20),
                child:  DataTableTheme(
                  data: DataTableThemeData(
                    headingTextStyle: TextStyle(
                      color: Colors.white
                    ),
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue), // Change the color here
                  ),
                  child: DataTable(

                    columnSpacing: 20, // Set your desired column spacing
                    dataRowHeight: 80,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'ID',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'pr_Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Usages',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Description',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),

                    ],
                    rows: data
                        .map(
                          (patient) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(patient['pr_no'].toString())),
                          DataCell(Text(patient['name'].toString())),
                          DataCell(Text(patient['pr_date'].toString())),
                          DataCell(Text(patient['pr_name'].toString())),
                          DataCell(Text(patient['usages'].toString())),
                          DataCell(Text(patient['description'].toString())),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
