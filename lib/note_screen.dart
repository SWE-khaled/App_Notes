import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const Color backgroundColor = Color(0xFFE0E0E0);
  static const Color titleColor = Colors.black;
  final _key = GlobalKey<FormState>();
  final _controller = TextEditingController();
  List<String> myNotes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                myNotes.clear();
                setState(() {});
              },
              child: Text(
                "Clear All",
                style: TextStyle(color: titleColor, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notes", style: TextStyle(fontSize: 48, color: titleColor)),
            SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                itemCount: myNotes.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 12);
                },
                itemBuilder: (context, index) => Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.text =myNotes[index];
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Form(
                              key: _key,
                              child: AlertDialog(
                                title: const Text('Update Note'),
                                content: TextFormField(
                                  controller: _controller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "You should add any content";
                                    }
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _key.currentState!.validate();
                                      if (_controller.text.isNotEmpty) {
                                           myNotes[index] = _controller.text;
                                        setState(() {
                                          Navigator.pop(context);
                                          _controller.text = "";
                                        });
                                      }
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 100,
                        width: 380,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18 ,right: 15 ,top: 12), 
                          child: Center(child: Text(myNotes[index])),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        myNotes.removeAt(index);
                        setState(() {});
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Form(
                key: _key,
                child: AlertDialog(
                  title: const Text('Add Note'),
                  content: TextFormField(
                    controller: _controller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "You should add any content";
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _key.currentState!.validate();
                        if (_controller.text.isNotEmpty) {
                          myNotes.add(_controller.text);
                          setState(() {
                            Navigator.pop(context);
                            _controller.text = "";
                          });
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

///Requirment:
///(3) update note
