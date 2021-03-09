import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.book,
              size: 68,
            ),
            SizedBox(
              height: 40,
            ),
            RichText(
                text: TextSpan(
                    text: "Login ".toUpperCase(),
                    style: GoogleFonts.modakTextTheme().headline3.copyWith(fontSize:38),
                    children: [
                  TextSpan(
                    text: "in With",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ])),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                signInCard(
                  text: "Teacher",
                  onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>TeacherHomePage()));
                  },
                ),
                signInCard(
                  text: "Student",
                  onPress: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class signInCard extends StatelessWidget {
  final text, onPress;

  const signInCard({
    this.text,
    this.onPress,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline6.copyWith(
                  letterSpacing: 2,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: onPress,
              icon: Icon(
                FontAwesomeIcons.google,
              ),
              label: Text(
                "  Google  Sign  In".toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DefaultTabController(
        initialIndex: currentIndex,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white54,
            title: Text(
              "Examination".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
            actions: [
              TextButton.icon(
                icon: Icon(
                  Icons.upload_sharp,
                  color: Colors.black,
                ),
                onPressed: () {},
                label: Text(
                  'Submit Copy'.toUpperCase(),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
            bottom: TabBar(
                onTap: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                automaticIndicatorColorAdjustment: true,
                isScrollable: false,
                physics: ScrollPhysics(),
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Text("Exam Paper"),
                    icon: Icon(CupertinoIcons.book_circle_fill),
                  ),
                  Tab(
                    child: Text("Paper Writing"),
                    icon: Icon(CupertinoIcons.book_solid),
                  ),
                ]),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              PdfPreviewWidget(
                  "http://www.africau.edu/images/default/sample.pdf"),
              Draw(),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfPreviewWidget extends StatefulWidget {
  String url;
  String title;
  bool isExam = false;
  var isCopyLoaded;

  PdfPreviewWidget(this.url, {this.isExam, this.title, this.isCopyLoaded});

  @override
  _PdfPreviewWidgetState createState() => _PdfPreviewWidgetState();
}

class _PdfPreviewWidgetState extends State<PdfPreviewWidget> {
  List<Widget> pdfList = [];
  int currentIndex = 0;
  var loading = true;
  List<Uint8List> images = [];

  @override
  void initState() {
    super.initState();
    getListFromPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              currentIndex = index;
              setState(() {});
            },
            child: Container(
              width: 60,
              height: 60,
              child: Stack(
                children: [
                  Image.memory(
                    images[index],
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  currentIndex == index
                      ? Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.deepOrange,
                            size: 40,
                          ))
                      : Container()
                ],
              ),
            ),
          ),
          itemCount: pdfList.length,
        ),
      ),
    );
  }

  getListFromPdf() async {
    var document = await FileUtils.downloadFile(widget.url, "studentImage");

    await for (var page in Printing.raster(document.readAsBytesSync())) {
      final image = await page.toPng();
      images.add(image);
      pdfList.add(Container(
        color: Colors.white,
        child: PhotoView(
          imageProvider: MemoryImage(image),
          backgroundDecoration: BoxDecoration(color: Colors.white),
        ),
      ));
    }
    setState(() {
      loading = false;
      if (widget.isCopyLoaded != null) widget.isCopyLoaded(true);
    });
  }
}

class FileUtils {
  static Future<File> downloadFile(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

//
// static Future<File> pdfFilePicker() async {
//   var result = await FilePicker.platform.pickFiles(
//       allowCompression: true,
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: ['pdf']);
//   if (result != null) {
//     var file = File(result.files.single.path);
//
//     return file;
//   }
// }
}

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = [];
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.album),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.StrokeWidth)
                              showBottomList = !showBottomList;
                            selectedMode = SelectedMode.StrokeWidth;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.opacity),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.Opacity)
                              showBottomList = !showBottomList;
                            selectedMode = SelectedMode.Opacity;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.color_lens),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.Color)
                              showBottomList = !showBottomList;
                            selectedMode = SelectedMode.Color;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            showBottomList = false;
                            points.clear();
                          });
                        }),
                  ],
                ),
                Visibility(
                  child: (selectedMode == SelectedMode.Color)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getColorList(),
                        )
                      : Slider(
                          value: (selectedMode == SelectedMode.StrokeWidth)
                              ? strokeWidth
                              : opacity,
                          max: (selectedMode == SelectedMode.StrokeWidth)
                              ? 50.0
                              : 1.0,
                          min: 0.0,
                          onChanged: (val) {
                            setState(() {
                              if (selectedMode == SelectedMode.StrokeWidth)
                                strokeWidth = val;
                              else
                                opacity = val;
                            });
                          }),
                  visible: showBottomList,
                ),
              ],
            ),
          ),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              scaffoldKey.currentState.showBottomSheet((context) => Container(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  backgroundColor: Colors.black12);
            },
            child: Icon(Icons.sort),
          )
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: CustomPaint(
          foregroundPainter: MyPainter(),
          size: Size.infinite,
          painter: DrawingPainter(
            pointsList: points,
          ),
        ),
      ),
    );
  }

  getColorList() {
    List<Widget> listWidget = [];
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() => selectedColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }

class MyPainter extends CustomPainter {
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 1;
    print(size.height / 50);

    for (int i = 1; i < size.height / 50.round(); i++) {
      canvas.drawLine(Offset(0, i * 50.0), Offset(size.width, i * 50.0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
