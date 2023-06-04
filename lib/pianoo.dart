import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

class Pianoo extends StatefulWidget {
  const Pianoo({Key? key});

  @override
  State<Pianoo> createState() => _PianooState();
}

class _PianooState extends State<Pianoo> {
  List<String> list = <String>['piano', 'Flute', 'Strings'];
  String? dropdownValue;
  FlutterMidi flutterMidi = FlutterMidi();

  void initState() {
    dropdownValue = list.first;
    loadAsset('assets/piano.sf2');
    super.initState();
  }

  void loadAsset(String asset) async {
    FlutterMidi().unmute(); // Optionally Unmute
    ByteData byteData = await rootBundle.load(asset);
    Uint8List sf2Bytes = byteData.buffer.asUint8List();
    flutterMidi.prepare(
        sf2: byteData,
        name: 'assets/$dropdownValue.sf2'.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              elevation: 16,
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  loadAsset('assets/$dropdownValue.sf2');
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([Clef.Treble]),
          onNotePositionTapped: (position) {
            flutterMidi.playMidiNote(midi: position.pitch);
          },
        ),
      ),
    );
  }
}
