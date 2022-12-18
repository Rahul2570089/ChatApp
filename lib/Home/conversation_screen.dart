import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/helper/constants.dart';
import 'package:mychatapp/services/database.dart';
import 'package:encryptor/encryptor.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ConversationScreen extends StatefulWidget {
  final String chatroomid;
  final String user;
  const ConversationScreen(this.chatroomid,this.user, {Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController textEditingController = TextEditingController();
  Stream? chatmsg;

  String? key;

  Widget chatMessageTile() {
    return StreamBuilder(
      stream: chatmsg,
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return Container();
        }
        return ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context,index) {
            return MessageTile(
              Encryptor.decrypt(key.toString(), (snapshot.data as QuerySnapshot).docs[index]["message"]).toString(),
              (snapshot.data as QuerySnapshot).docs[index]["sender"] == constants.name 
            );
          }
        );
      }
    );
  }

  sendMessages() {
    if(textEditingController.text.isNotEmpty) {
      Map<String,dynamic> msgmap = {
        "message" : Encryptor.encrypt(key.toString(), textEditingController.text),
        "sender" : constants.name,
        "time" : "${DateTime.now().hour}:${DateTime.now().minute}",
        "timeOrder" : DateTime.now().millisecondsSinceEpoch,
      };
    dataBaseMethods.addConversationMsg(widget.chatroomid, msgmap);
    textEditingController.text = "";
    }
  }
  
  @override
  void initState() {
    super.initState();
    key = encrypt.Key.fromUtf8(widget.chatroomid).toString();
    dataBaseMethods.getConversationMsg(widget.chatroomid).then((val) {
      setState(() {
        chatmsg = val;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user,style: const TextStyle(color: Colors.black),),
        backgroundColor: Colors.green[50],
          elevation: 0.0,
          shadowColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.green
          ),
      ),
      body: Container(
        color: Colors.green[100],
        child: Stack(
          children: [
            chatMessageTile(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: const Color(0x54FFFFFF),
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      )
                    ),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        elevation: 0.0,
                        onPressed: () {
                          sendMessages();
                        },
                        backgroundColor: Colors.greenAccent,
                        child: const Icon(Icons.send,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String msg;
  final bool sender;
  const MessageTile(this.msg,this.sender, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: sender ? 0 : 20, right: sender ? 20 : 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: sender ? [Colors.green,Colors.green.shade400] : [Colors.white30,Colors.white70],
          ),
          borderRadius: sender ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ) : 
          const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)
          )
        ),
        child: Text(
          msg,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}