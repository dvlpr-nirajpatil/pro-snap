import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/core/services/socket_service.dart';
import 'package:prosnap/features/chating/models/chat_details_model.dart';
import 'package:prosnap/features/chating/models/message_model.dart';
import 'package:prosnap/features/chating/repository/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository repository = ChatRepository();
  final TextEditingController messageController = TextEditingController();
  Rxn<ChatDetailsModel> chatDetails = Rxn<ChatDetailsModel>();
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxBool isSending = false.obs;
  final SocketService socket = Get.find<SocketService>();

  @override
  onInit() {
    super.onInit();
    getChatDetails();
    getInitialChats();
    listenLiveMessage();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  getChatDetails() async {
    try {
      chatDetails.value = await repository.getChatDetails(Get.arguments);
    } catch (e) {
      errorHandle(e);
    }
  }

  getInitialChats() async {
    try {
      final response = await repository.getMessages(Get.arguments);
      final List rawMessages = response['data']['messages'];
      messages.value =
          rawMessages.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      handelError(e);
    }
  }

  sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

    isSending.value = true;
    try {
      final response = await repository.sendMessage(
        conversationId: Get.arguments,
        text: text,
        image: null,
      );

      final rawMessage = response['data']?['message'];
      if (rawMessage is Map<String, dynamic>) {
        messages.insert(0, MessageModel.fromJson(rawMessage));
      } else {
        messages.insert(
          0,
          MessageModel(
            conversation: Get.arguments,
            sender: CurrentUser().id,
            text: text,
          ),
        );
      }
      messageController.clear();
    } catch (e) {
      errorHandle(e);
    } finally {
      isSending.value = false;
    }
  }

  listenLiveMessage() {
    socket.listenEvent("new-message", (message) {
      logger.d(message);
      final conversationId = message['conversationId'];
      if (conversationId == Get.arguments) {
        final rawMessage = message['message'];
        messages.insert(0, MessageModel.fromJson(rawMessage));
      }
    });
  }
}
