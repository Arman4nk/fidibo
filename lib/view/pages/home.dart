import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  //for forcing rebuild the image component
  late GlobalKey imageKey;

  Offset? start;

  _startSwipe(DragStartDetails details){
    //save first point that start the Swipe
    start = details.localPosition;
  }

  _endSwipe(DragEndDetails details){
   print(details.velocity);
    //print(details.velocity.pixelsPerSecond);
   // print(details.primaryVelocity);
   //  details.primaryVelocity
  }

  @override
  void initState() {
    imageKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fibdo Task'),
      ),
      body: GestureDetector(
        onPanStart: _startSwipe,
        onPanEnd: _endSwipe,
       // onPanDown: ,
        //onPanUpdate: ,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Center(
            child: Image.network(
              'https://picsum.photos/200',
              key: imageKey,
              width: 200,
              height: 200,
              loadingBuilder: (_, child, dd) => child,
            ),
          ),
        ),
      ),
    );
  }
}
