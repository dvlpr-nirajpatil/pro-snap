import 'package:get/get.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/services/socket_service.dart';
import 'package:prosnap/features/conversations/models/conversation_model.dart';
import 'package:prosnap/features/conversations/repository/conversation_repository.dart';
import 'package:prosnap/features/chating/views/chating_screen.dart';

class ConversationController extends GetxController {
  final ConversationRepository repository = ConversationRepository();
  final SocketService socket = Get.find<SocketService>();

  RxBool isLoading = false.obs;
  RxList<ConversationModel> conversations = <ConversationModel>[].obs;

  @override
  onInit() {
    super.onInit();
    getConversations();
    listenLiveConversations();
  }

  @override
  onClose() {
    socket.stopListening("conversation-updated");
  }

  createConversation({required String userId}) async {
    isLoading.value = true;
    try {
      final conversationId = await repository.createConversation(
        receiverId: userId,
      );
      Get.to(() => ChatingScreen(), arguments: conversationId);
    } catch (e) {
      errorHandle(e);
    } finally {
      isLoading.value = false;
    }
  }

  getConversations() async {
    try {
      final response = await repository.getConversation();
      final List rawConversations = response['data']['conversations'];
      conversations.value =
          rawConversations.map((e) => ConversationModel.fromJson(e)).toList();
    } catch (e) {
      errorHandle(e);
    }
  }

  listenLiveConversations() {
    socket.listenEvent("conversation-updated", (conversation) {
      conversations.value =
          conversations.where((e) => e.id != conversation['_id']).toList();
      conversations.insert(0, ConversationModel.fromJson(conversation));
    });
  }
}
