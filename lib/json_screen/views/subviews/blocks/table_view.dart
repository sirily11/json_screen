import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/utils.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';

class TableView extends StatelessWidget {
  final TableBlock tableBlock;

  TableView({this.tableBlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Text(
            tableBlock.content,
            style: Theme.of(context).textTheme.headline6,
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: tableBlock.columns
                    .map((e) => DataColumn(label: renderBlock(e)))
                    .toList(),
                rows: tableBlock.rows
                    .map(
                      (e) => DataRow(
                        cells:
                            e.map((el) => DataCell(renderBlock(el))).toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
