import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'cryption.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  MaterialColor primarySwatch = Colors.purple;

  final inputEController = TextEditingController();
  final outputEController = TextEditingController();

  final inputDController = TextEditingController();
  final outputDController = TextEditingController();

  final _scrollControllerEInput = ScrollController();
  final _scrollControllerEOutput = ScrollController();
  final _scrollControllerDInput = ScrollController();
  final _scrollControllerDOutput = ScrollController();

  final keyE = GlobalKey();
  final keyD = GlobalKey();

  @override
  void dispose() {
    inputEController.dispose();
    outputEController.dispose();
    inputDController.dispose();
    outputDController.dispose();
    _scrollControllerEInput.dispose();
    _scrollControllerEOutput.dispose();
    _scrollControllerDInput.dispose();
    _scrollControllerDInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragCancel: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'OpenSans',
          primarySwatch: primarySwatch,
          //transparent color removes 'splashes' and highlights of buttons
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            //overflowing error appeared when mobile keyboard opened
            //this removes that
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: primarySwatch[600],
              title: const Center(child: Text('CRYPTION', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ))),
              bottom: const PreferredSize(
                preferredSize: Size(0, 40.0),
                child: TabBar(
                  indicatorColor: Colors.white,
                  tabs: <Widget>[
                    SizedBox(
                      height: 40,
                      child: Text('Encryption', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),),
                    ),
                    SizedBox(
                      height: 40,
                      child: Text('Decryption', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),),
                    ),
                  ],
                ),
              ),
            ),
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(content: Text('Tap back again to leave'),),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: TabBarView(
                  children: <Widget>[
                    //Encryption
                    Center(
                      child: Column(
                        children: [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: FractionallySizedBox(
                              widthFactor: 0.93,
                              heightFactor: 0.9,
                              child: RawScrollbar(
                                interactive: false,
                                crossAxisMargin: -10,
                                thumbColor: const Color(0xff999999),
                                radius: const Radius.circular(20),
                                thickness: 5,
                                controller: _scrollControllerEInput,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  textInputAction: TextInputAction.newline,
                                  onChanged: (value) {
                                    outputEController.text =
                                        Cryption.encryptionText(value);
                                  },
                                  scrollController: _scrollControllerEInput,
                                  controller: inputEController,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Enter message...',
                                    suffixIcon: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 0,
                                      ),
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        padding: const EdgeInsets.only(top: 20),
                                        icon: const Icon(Icons.clear),
                                        iconSize: 30,
                                        onPressed: () {
                                          _scrollControllerEInput.jumpTo(0);
                                          inputEController.clear();
                                          outputEController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 25,),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: FractionallySizedBox(
                              widthFactor: 0.93,
                              heightFactor: 0.9,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.1, 1.0],
                                    colors: [Color(0xFFE8E8E8), Color(0xFFFAFAFA)],
                                  ),
                                ),
                                child: RawScrollbar(
                                  interactive: false,
                                  crossAxisMargin: -10,
                                  thumbColor: const Color(0xff999999),
                                  radius: const Radius.circular(20),
                                  thickness: 5,
                                  controller: _scrollControllerEOutput,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.top,
                                    scrollController: _scrollControllerEOutput,
                                    controller: outputEController,
                                    maxLines: null,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Encrypted message',
                                      suffixIcon: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 0,
                                        ),
                                        alignment: Alignment.topRight,
                                        child: Tooltip(
                                          key: keyE,
                                          verticalOffset: 40,
                                          message: "Copied",
                                          triggerMode: TooltipTriggerMode.manual,
                                          child: IconButton(
                                            padding: const EdgeInsets.only(top: 30, right: 20),
                                            icon: const Icon(IconData(0xe190, fontFamily: 'MaterialIcons'),),
                                            iconSize: 30,
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: outputEController.text));
                                              final dynamic tooltip = keyE.currentState;
                                              tooltip.ensureTooltipVisible();
                                              Future.delayed(const Duration(seconds: 1), () {
                                                tooltip?.deactivate();
                                              }
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 25,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: FractionallySizedBox(
                              widthFactor: 0.93,
                              heightFactor: 0.9,
                              child: RawScrollbar(
                                interactive: false,
                                crossAxisMargin: -10,
                                thumbColor: const Color(0xff999999),
                                radius: const Radius.circular(20),
                                thickness: 5,
                                controller: _scrollControllerDInput,
                                isAlwaysShown: true,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  textInputAction: TextInputAction.newline,
                                  onChanged: (value) {
                                    outputDController.text =
                                        Cryption.decryptionText(value);
                                  },
                                  controller: inputDController,
                                  scrollController: _scrollControllerDInput,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Enter encrypted text...',
                                    suffixIcon: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 0,
                                      ),
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        padding: const EdgeInsets.only(top: 20),
                                        icon: const Icon(Icons.clear),
                                        iconSize: 30,
                                        onPressed: () {
                                          _scrollControllerDInput.jumpTo(0);
                                          inputDController.clear();
                                          outputDController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 25,),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            fit: FlexFit.tight,
                            child: FractionallySizedBox(
                              widthFactor: 0.93,
                              heightFactor: 0.9,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.1, 1.0],
                                    colors: [Color(0xFFE8E8E8), Color(0xFFFAFAFA)],
                                  ),
                                ),
                                child: RawScrollbar(
                                  interactive: false,
                                  crossAxisMargin: -10,
                                  thumbColor: const Color(0xff999999),
                                  radius: const Radius.circular(20),
                                  thickness: 5,
                                  controller: _scrollControllerDOutput,
                                  isAlwaysShown: true,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.top,
                                    controller: outputDController,
                                    scrollController: _scrollControllerDOutput,
                                    maxLines: null,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Decrypted message',
                                      suffixIcon: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 0,
                                        ),
                                        alignment: Alignment.topRight,
                                        child: Tooltip(
                                          key: keyD,
                                          verticalOffset: 40,
                                          message: "Copied",
                                          triggerMode: TooltipTriggerMode.manual,
                                          child: IconButton(
                                            padding: const EdgeInsets.only(top: 30, right: 20),
                                            icon: const Icon(IconData(0xe190, fontFamily: 'MaterialIcons'),),
                                            iconSize: 30,
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: outputDController.text));
                                              final dynamic tooltip = keyD.currentState;
                                              tooltip.ensureTooltipVisible();
                                              Future.delayed(const Duration(seconds: 1), () {
                                                tooltip?.deactivate();
                                              }
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 25,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}

