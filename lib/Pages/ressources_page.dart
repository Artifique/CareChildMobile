import 'dart:io';
import 'package:accessability/Services/ressource_service.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:accessability/Widgets/pdf_widget.dart';
import 'package:accessability/Widgets/video_widget.dart';
import 'package:accessability/Modele/ressource_modele.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class RessourcesPage extends StatefulWidget {
  const RessourcesPage({super.key});

  @override
  State<RessourcesPage> createState() => _RessourcesPageState();
}

class _RessourcesPageState extends State<RessourcesPage> {
  int _selectedIndex = 0; 
  final RessourceService _ressourceService = RessourceService();
  List<Ressource> _audioRessources = [];
  List<Ressource> _pdfRessources = [];
  List<Ressource> _videoRessources = [];

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    try {
      _audioRessources = await _ressourceService.recupererRessourcesAudio();
      _pdfRessources = await _ressourceService.recupererRessourcesPdf();
      _videoRessources = await _ressourceService.recupererRessourcesVideo();
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de chargement des ressources : $e');
      }
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAudioContent();
      case 1:
        return _buildPdfContent();
      case 2:
        return _buildVideoContent();
      default:
        return const SizedBox();
    }
  }

  Widget _buildAudioContent() {
    return SingleChildScrollView(
      child: Column(
        children: _audioRessources.map((ressource) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomRessource(
              100,
              300,
              20,
              Image.asset(ressource.imageRepresentation),
              ressource.titre,
              Colors.white,
              Colors.black,
              const Color(0xff0B8FAC),
              130,
              12,
              Icons.mic,
              () {
                // Logic to play audio
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPdfContent() {
    return SingleChildScrollView(
      child: Column(
        children: _pdfRessources.map((ressource) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: () {
                _downloadAndViewPdf(ressource.url);
              },
              child: FilePreviewWidget(
                        fileName: ressource.titre,
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVideoContent() {
    return SingleChildScrollView(
      child: Column(
        children: _videoRessources.map((ressource) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: VideoPreviewWidget(
              videoTitle: ressource.titre,
              videoDescription: ressource.idSpecialiste,
              videoUrl: ressource.url,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _downloadAndViewPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);
      
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(filePath: file.path),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors du téléchargement du PDF : $e");
      }
      // Gérez l'erreur ici, par exemple, afficher un message à l'utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B8FAC),
      appBar: AppBar(
        title: const Text(
          'Ressources',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff0B8FAC),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 41, 40, 40).withOpacity(0.5),
                    offset: const Offset(0, 5),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildButton('Langue', 0),
                          _buildButton('Documents', 1),
                          _buildButton('Vidéo', 2),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: _buildContent()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return ElevatedButton(
      onPressed: () => _onButtonTapped(index),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? const Color(0xff0B8FAC) : Colors.white,
        backgroundColor: isSelected ? Colors.white : const Color(0xff0B8FAC),
        side: BorderSide(color: const Color(0xff0B8FAC), width: isSelected ? 2 : 0),
        padding: const EdgeInsets.all(10),
        textStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      child: Text(title),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String filePath;

  // ignore: use_super_parameters
  const PdfViewerPage({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: filePath,
        onError: (error) {
          if (kDebugMode) {
            print("Error loading PDF: $error");
          }
        },
      ),
    );
  }
}