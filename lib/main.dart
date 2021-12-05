// @dart=2.9
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Chatbot());
}

class Chatbot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: ChatbotHome(),
    );
  }
}

class ChatbotHome extends StatefulWidget {
  @override
  _ChatbotHomeState createState() => _ChatbotHomeState();
}

class _ChatbotHomeState extends State<ChatbotHome> {
  final TextEditingController controllerUser = TextEditingController();
  final DialogFlowtter _dialogFlowtter = DialogFlowtter();
  List<Map<String, dynamic>> messages = [];

  void sendMessageUser(String text) async {
    if (text.isEmpty) return;
    setState(() {
      Message userMessage = Message(text: DialogText(text: [text]));
      addMessage(userMessage, true);
    });

   final QueryInput queryInput = QueryInput(text: TextInput(text: text));

    DetectIntentResponse response = await _dialogFlowtter.detectIntent(
      queryInput: queryInput,
    );

    print(response);

    if (response.message == null) return;
    setState(() {
      addMessage(response.message);
    });
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot Tienda'),
      ),
      body: Column(
        children: [
          Expanded(child: MessageList(messages: messages)),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: controllerUser,
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessageUser(controllerUser.text);
                    controllerUser.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const MessageList({Key key, this.messages = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: messages.length,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        separatorBuilder: (_, i) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          var obj = messages[messages.length - 1 - i];
          return MessageContainer(
              message: obj['message'], isUserMessage: obj['isUserMessage']);
        },
        reverse: true);
  }
}

class MessageContainer extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const MessageContainer(
      {Key key, @required this.message, this.isUserMessage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              constraints: BoxConstraints(maxWidth: 250),
              child: Container(
                decoration: BoxDecoration(
                    color: isUserMessage ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
                child: Text(
                  message?.text?.text[0] ?? '',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ))
        ]);
  }
}
