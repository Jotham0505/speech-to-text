import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SpeechToText speechToText = SpeechToText();
  var isListening = false;
  var textSpeech = "CLICK MIC TO RECORD";

  void checkMic() async{
    bool micAvailable = await speechToText.initialize();

    if (micAvailable) {
      print('Microphone Available');
    } else {
      print("User denied the use of microphone");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkMic();
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Click on the mic to record"
              ),
              GestureDetector(
                onTap: () async{
                  if (!isListening) {
                    bool micAvailable = await speechToText.initialize();

                    if (micAvailable) {
                      setState(() {
                        isListening = true;
                      });
                      speechToText.listen(
                        listenFor: Duration(seconds: 20),
                        onResult: (result) {
                          setState(() {
                            textSpeech = result.recognizedWords;
                            print(textSpeech);
                            isListening = false;
                          });
                        },
                      );
                    }
                  } else {
                    setState(() {
                      isListening = false;
                      speechToText.stop();
                    });
                  }
                },
                child: CircleAvatar(
                  child: isListening? Icon(Icons.record_voice_over): Icon(Icons.mic),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
