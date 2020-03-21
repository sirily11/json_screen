import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/models/block.dart';
import 'package:json_screen/json_screen/models/utils.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';

class TableView extends StatelessWidget {
  final OnLinkTap onLinkTap;
  final OnImageTap onImageTap;
  final TableBlock tableBlock;

  TableView({this.tableBlock, this.onLinkTap, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    bool found = tableBlock.rows.firstWhere(
            (element) => element.length != tableBlock.columns.length,
            orElse: () => null) !=
        null;

    if (found) {
      return Center(
        child: Text(
          "Column length not equals to row's length",
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Text(
            tableBlock.content,
            style: Theme.of(context).textTheme.headline6,
          ),
          Center(
            child: tableBlock.columns.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: tableBlock.columns
                          .map((e) => DataColumn(
                              label: renderBlock(e, onLinkTap, onImageTap)))
                          .toList(),
                      rows: tableBlock.rows
                          .map(
                            (e) => DataRow(
                              cells: e
                                  .map((el) => DataCell(
                                      renderBlock(el, onLinkTap, onImageTap)))
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : Text("Column should not be empty"),
          ),
        ],
      ),
    );
  }
}
