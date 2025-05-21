import 'package:flutter/material.dart';
import 'package:how_old/date_mask.dart';

void main() {
  runApp(const MyApp());
}

const _inputTextStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 15,
  fontWeight: FontWeight.normal,
  wordSpacing: 0,
  letterSpacing: 0,
  color: Colors.black,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _editingController = TextEditingController();
  final _hintTextStyle = _inputTextStyle.copyWith(color: Colors.black45);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                TextField(
                  controller: _editingController,
                  onChanged: (text) {
                    setState(() {});
                  },
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [DateMask()],
                  decoration: InputDecoration(
                    hintText: 'dd/mm/yyyy',
                    hintStyle: _hintTextStyle,
                  ),
                  style: _inputTextStyle,
                ),
                Positioned(
                  left:
                      boundingTextSize(
                        _editingController.text,
                        _inputTextStyle,
                      ).width,
                  top: 12,
                  child: Visibility(
                    visible: _editingController.text.isNotEmpty,
                    child: Text('/mm/yyyy', style: _hintTextStyle),
                  ),
                ),
              ],
            ),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  static Size boundingTextSize(
    String text,
    TextStyle style, {
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
  }) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}
