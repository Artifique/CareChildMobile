import 'package:accessability/Services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Modele/message_modele.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:intl/intl.dart';

class MessageContenuPage extends StatefulWidget {
  final String name;
  final String idGroupe;
  final String recepteurId;
  final String imageUrl;
  final List<String> participantsIds;

  const MessageContenuPage({
    super.key,
    required this.name,
    required this.idGroupe,
    required this.recepteurId,
    required this.imageUrl,
    required this.participantsIds,
  });

  @override
  _MessageContenuPageState createState() => _MessageContenuPageState();
}

class _MessageContenuPageState extends State<MessageContenuPage> {
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final UtilisateurService _utilisateurService = UtilisateurService();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _fetchMessages() async {
    if (currentUserId != null) {
      try {
        _messageService.recevoirMessages(widget.idGroupe.isNotEmpty ? widget.idGroupe : null, currentUserId!).listen((messages) {
          setState(() {
            _messages.clear();
            _messages.addAll(messages);
          });
        });
      } catch (e) {
        // Gérer l'erreur (afficher un message ou journaliser)
      }
    }
  }

  Future<void> _getCurrentUserId() async {
    final utilisateur = await _utilisateurService.getCurrentUtilisateur();
    setState(() {
      currentUserId = utilisateur?.id;
      _fetchMessages(); // Appeler la récupération des messages après avoir obtenu l'ID utilisateur
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0B8FAC),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.imageUrl.isNotEmpty
                  ? NetworkImage(widget.imageUrl)
                  : const AssetImage('images/default_image.png') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(context, _messages[index], index);
              },
            ),
          ),
          _buildMessageInputField(context),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, Message message, int index) {
    bool isReceived = message.emetteurId != currentUserId;

    String? dateLabel;
    if (index == 0 || !_isSameDay(_messages[index - 1].dateEnvoi, message.dateEnvoi)) {
      dateLabel = _formatDateLabel(message.dateEnvoi);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dateLabel != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              dateLabel,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Align(
          alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
          child: GestureDetector(
            onLongPress: () {
              if (!isReceived) {
                _showDeleteConfirmationDialog(message);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: isReceived ? const Color(0xffE9F4FB) : const Color(0xff0B8FAC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: isReceived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    message.contenu,
                    style: TextStyle(
                      color: isReceived ? Colors.black87 : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatTime(message.dateEnvoi),
                    style: TextStyle(
                      color: isReceived ? Colors.black54 : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return "Aujourd'hui";
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return "Hier";
    } else {
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm().format(date);
  }

  Widget _buildMessageInputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Tapez votre message...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xff0B8FAC)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty && currentUserId != null) {
      final String messageContent = _messageController.text.trim();
      final String senderId = currentUserId!;
      final String? recepteurId = widget.recepteurId;

      // Vérifiez si un ID de groupe est fourni pour déterminer le type de message
      String? idGroupe = widget.idGroupe.isNotEmpty ? widget.idGroupe : null;

      setState(() {
        _messages.add(Message(
          idMessage: '',
          contenu: messageContent,
          emetteurId: senderId,
          idGroupe: idGroupe,
          recepteurId: recepteurId!,
          dateEnvoi: DateTime.now(),
        ));
        _messageController.clear();
      });

      try {
        await _messageService.envoyerMessage(
          senderId,
          recepteurId!,
          messageContent,
          idGroupe: idGroupe,
        );
      } catch (e) {
        // Gérer l'erreur lors de l'envoi du message
      }
    }
  }

  void _showDeleteConfirmationDialog(Message message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le message'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce message ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                setState(() {
                  _messages.remove(message);
                });
                _messageService.supprimerMessage(message.idMessage);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}