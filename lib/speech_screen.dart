import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool languageEn = false;
  String _text = "";

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Speech To Text", style: GoogleFonts.italianno(fontSize: 30),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    languageEn= !languageEn;
                  });
                },
                icon: const Icon(Icons.language_sharp,size: 25,),
              splashRadius: 20,

            )
          )
        ],
        centerTitle: true,
      ),
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.red.shade400,
        endRadius: 70,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed:(){
            languageEn? _listen('en_EN'):_listen('ar_AR');
          },
          backgroundColor: Colors.black,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_off, color: Colors.white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30,10,30,50),
              child: Text(_isListening
                  ? _text
                  : languageEn? 'Tap the microphone to \n  start listening':'اضغط علي الميكرفون لبداء التحدث',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.w500
                ),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            )
          ),
      ),
    );
  }


  void _listen(String localeId) async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: localeId,

          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

}


