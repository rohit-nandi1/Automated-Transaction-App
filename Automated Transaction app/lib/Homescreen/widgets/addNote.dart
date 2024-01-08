import 'package:expense/Provider/database.dart';
import 'package:expense/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  bool isEdit;
  Map data;

  AddNote({
    required this.isEdit,
    required this.maxWidth,
    required this.data,
  });

  final double maxWidth;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final noteController = new TextEditingController();
  final amountController = new TextEditingController();
  List category = [
    "Unspecified",
    "Food",
    "Shopping",
    "Health",
    "Transport",
    "Gift",
    "Household",
    "Beauty",
    "Other",
  ];
  String selectedCategory = "Unspecified";
  String selectedType = "Expense";

  Future<void> addAmount(BuildContext context2) async {
    if (amountController.text == "") {
      ScaffoldMessenger.of(context2).showSnackBar(new SnackBar(
        content: Text(
          "Please enter the amount!",
        ),
        duration: Duration(milliseconds: 1500),
      ));
      return;
    }

    Map<String, Object> data;
    print(widget.isEdit);
    if (!widget.isEdit) {
      data = {
        "id": DateTime.now().toString(),
        "note": noteController.text,
        "amount": amountController.text,
        "type": selectedType,
        "category": selectedCategory,
        "date": DateTime.now().toString().substring(0, 10),
        "takenFrom": "user",
      };
      Provider.of<Database>(context, listen: false).addToTable(data);
    } else {
      // print(noteController.text);
      // print(amountController.text);
      // print(selectedType);
      // print(selectedCategory);
      // print(widget.data);
      // print(widget.data["date"]);
      // print(widget.data["takenFrom"]);
      data = {
        // "id": DateTime.now().toString(),
        "note": noteController.text,
        "amount": amountController.text,
        "type": selectedType,
        "category": selectedCategory,
        "date": widget.data["date"],
        "takenFrom": widget.data["takenFrom"],
      };
      // print(data.toString());
      Provider.of<Database>(context, listen: false).updateData(data, widget.data["id"]);
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      noteController.text = widget.data["text"];
      selectedCategory = widget.data["category"];
      amountController.text = widget.data["amount"];
      selectedType = widget.data["type"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
          builder: (context2) => Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 10),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    width: widget.maxWidth / 1,
                    height: 650,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          label("Amount"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.maxFinite,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(196, 196, 196, 0.16),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              maxLines: null,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Enter the amount",
                                hintStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white38,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          label("Note"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.maxFinite,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(196, 196, 196, 0.16),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: noteController,
                              maxLines: null,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Write a note here",
                                hintStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white38,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          label("Category"),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                                child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2.5 / 1,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (ctx, i) {
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    selectedCategory = category[i];
                                  }),
                                  child: Container(
                                    // margin: EdgeInsets.only(right: 10),
                                    height: 40,
                                    // width: 110,
                                    decoration: BoxDecoration(
                                        color: selectedCategory == category[i] ? Color.fromRGBO(196, 196, 196, 0.16) : mainColor,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white,
                                        )),
                                    child: Center(
                                      child: Text(
                                        category[i],
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: category.length,
                              shrinkWrap: true,
                            )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          label("Type"),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  selectedType = "Income";
                                }),
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: selectedType == "Income" ? Colors.white : Colors.transparent,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(69, 69, 69, 1),
                                          offset: Offset(-3.74, -3.74),
                                          blurRadius: 11.21,
                                        ),
                                        BoxShadow(
                                          color: Color.fromRGBO(9, 5, 5, 0.25),
                                          offset: Offset(5.6, 5.6),
                                          blurRadius: 11.21,
                                        )
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "Income",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 16,
                                        color: Color.fromRGBO(74, 209, 120, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  selectedType = "Expense";
                                }),
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: selectedType == "Expense" ? Colors.white : Colors.transparent,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(69, 69, 69, 1),
                                          offset: Offset(-3.74, -3.74),
                                          blurRadius: 11.21,
                                        ),
                                        BoxShadow(
                                          color: Color.fromRGBO(9, 5, 5, 0.25),
                                          offset: Offset(5.6, 5.6),
                                          blurRadius: 11.21,
                                        )
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "Expense",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 16,
                                        color: Color.fromRGBO(255, 105, 105, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  elevation: MaterialStateProperty.all(0),
                                                  shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(30.0),
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor: MaterialStateProperty.all(
                                                    Color.fromRGBO(255, 105, 105, 1),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  addAmount(context2);
                                                },
                                                child: widget.isEdit
                                                    ? Text(
                                                        "Update transaction",
                                                        style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      )
                                                    : Text(
                                                        "Add transaction",
                                                        style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        widget.isEdit
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          elevation: MaterialStateProperty.all(0),
                                                          shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(30.0),
                                                              ),
                                                            ),
                                                          ),
                                                          backgroundColor: MaterialStateProperty.all(
                                                            Color.fromRGBO(255, 105, 105, 1),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Provider.of<Database>(context, listen: false).deleteTx(widget.data["id"]);
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text(
                                                          "Delete transaction",
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }

  Padding label(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
