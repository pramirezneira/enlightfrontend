import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/chat_bubble.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/pages/chat/chat.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: context.read<MessagingService>().chats,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              width: 500,
              child: ListView.builder(
                itemCount: snapshot.data!.chats.length,
                itemBuilder: (context, index) => ChatBubble(
                  onTap: () {
                    context.read<MessagingService>().readMessages(index);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Chat(
                          senderId: snapshot.data!.accountId,
                          receiver: snapshot.data!.chats[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                  index: index,
                  name: snapshot.data!.chats[index].name,
                  picture: snapshot.data!.chats[index].picture,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AwesomeSnackbarContent(
                  title: "Error",
                  message: "Error loading chats",
                  contentType: ContentType.failure,
                ),
              ),
            );
          }
          return const LoadingIndicator(visible: true);
        },
      ),
    );
  }
}
