import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'Commons/CommonFunctions.dart';
import 'Widgets/ChatBubble.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;

  ChatScreen({required this.userId, required this.userName, required this.userImage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _messageController = TextEditingController();
  String storageBaseURL = CommonFunctions.storageBaseURL;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  String getChatRoomId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join("_");
  }


  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }

  Future<void> _sendImage() async {
    String chatRoomId = getChatRoomId(currentUserId!, widget.userId);
    if (_selectedImage == null) return;

    // Upload image to Firebase Storage
    final ref = _storage.refFromURL(storageBaseURL).child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(_selectedImage!);
    final imageUrl = await ref.getDownloadURL();
    Timestamp serverTimestamp = Timestamp.now();
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    // Save image URL to Firestore
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'type': 'image',
      'imageUrl': imageUrl,
      'senderId': currentUserId,
      'receiverId': widget.userId,
      'timestamp': serverTimestamp,
      'formattedTime': formattedTime,
    });

    // Clear selected image
    setState(() {
      _selectedImage = null;
    });

    // Scroll to the latest message
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendMessage() async {
    String chatRoomId = getChatRoomId(currentUserId!, widget.userId);
    Timestamp serverTimestamp = Timestamp.now();
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    if (_messageController.text.isNotEmpty) {
      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'type': 'text',
        'text': _messageController.text,
        'senderId': currentUserId,
        'timestamp': serverTimestamp,
        'formattedTime': formattedTime,
      });
      _messageController.clear();

      // Scroll to the latest message
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Center(child: CircularProgressIndicator());
    }
    String chatRoomId = getChatRoomId(currentUserId!, widget.userId);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.userImage == 'NULL' || widget.userImage.isEmpty
                  ? AssetImage('assets/images/farmer.png')
                  : NetworkImage(widget.userImage),
            ),
            SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == currentUserId;
                    final isImage = message['type'] == 'image';
                    final time = message['formattedTime'] ?? DateTime.now();

                    return ChatBubble(
                      message: isImage ? '' : message['text'],
                      time: time,
                      isMe: isMe,
                      isImage: isImage,
                      imageUrl: isImage ? message['imageUrl'] : null,
                    );
                  },
                );
              },
            ),
          ),
          if (_selectedImage != null)
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendImage,
                  ),
                ),
              ],
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _takePhoto,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),

                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}