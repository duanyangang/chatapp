import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:last_try/helper/constants.dart';
import 'package:last_try/model/database.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({required this.chatRoomId}) : super();

  final String chatRoomId;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  // QuerySnapshot<Map<String, dynamic>>? chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chatroom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MesasgeTile(
                      message: (snapshot.data!.docs[index].data()
                          as dynamic)["message"],
                      isSendByMe: Constants.myName ==
                          (snapshot.data!.docs[index].data()
                              as dynamic)["sendBy"],
                    );
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // databaseMethods.getConversationMessage(widget.chatRoomId).then((val) {
  //     if (val != null) {
  //       return setState(() {
  //         chatMessagesStream = val;
  //       });
  //     } else {
  //       print("ggwp");
  //     }
  //   });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(hintText: "message"),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        // searchList();
                        sendMessage();
                      },
                      child: Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MesasgeTile extends StatelessWidget {
  const MesasgeTile({required this.message, required this.isSendByMe})
      : super();
  final String? message;
  final bool isSendByMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            color: isSendByMe ? Colors.pink : Colors.blue),
        child: Text(message!),
      ),
    );
  }
}
