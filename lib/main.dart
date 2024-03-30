import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerScreen(
        name: 'Dinda Rachma Ayu Mauliza', 
        nim: '222410102056',
      ),
    );
  }
}

class TimerScreen extends StatefulWidget {
  final String name; //variabel final yang digunakan sebagai parameter untuk widget TimerScreen
  final String nim;

  TimerScreen({required this.name, required this.nim}); //const untuk membangun instance dari TimerScreen

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> { //widget stateful untuk menyimpan state yang dapat diubah
  double _seconds = 0; //variabel untuk menyimpan jumlah detik yang tersisa
  double _durationInMinutes = 0; //variabel untuk menyimpan durasi yang diinputkan dalam bentuk menit
  bool _isActive = false;
  late Timer _timer; //variabel untuk menyimpan instance dari kelas Timer
  late int _remainingSeconds;
  TextEditingController _controller = TextEditingController(); //membuat instans dari kelas TextEditingController untuk mengontrol nilai teks yang diinputkan

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Timer'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Name: ${widget.name}',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'NIM: ${widget.nim}',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _seconds > 0
                        ? '${(_seconds ~/ 60).toInt()} menit ${(_seconds % 60).toInt()} detik'
                        : _isActive
                            ? 'Times up!'
                            : 'Enter Time (minutes)',
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Type Here!',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _durationInMinutes = double.tryParse(value) ?? 0; //mengkonversikan inputan menjadi angka dan menyimpan ke variabel _durationInMinutes
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _isActive
                            ? _pauseTimer
                            : _seconds == 0
                                ? _startTimer
                                : _resumeTimer,
                        child: Text(
                          _isActive ? 'Pause' : _seconds == 0 ? 'Start' : 'Resume', //menampilkan label tombol sesuai state yang aktif
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _resetTimer,
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _startTimer() { //method yang akan dijalankan ketika tombol start ditekan
    setState(() {
      _seconds = _durationInMinutes * 60; //menghitung durasi dalam detik
      _isActive = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { //method yang dijalankan setiap 1 detik untuk mengurangi jumlah detik yang tersisa
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel(); //untuk membatalkan timer
          _isActive = false;
        }
      });
    });
  }

  void _pauseTimer() { //method yang akan dijalankan ketika tombol pause ditekan
    if (_timer != null && _timer.isActive) { //memastikan instance dari kelas Timer telah dibuat
      _timer.cancel();
      setState(() {
        _isActive = false;
        _remainingSeconds = _seconds.toInt(); //membuat variabel yang menyimpan
      });
    }
  }

  void _stopTimer() { //method yang akan dijalankan ketika tombol stop ditekan
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      setState(() {
        _isActive = false;
      });
    }
  }

  void _resumeTimer() { //method yang akan dijalankan ketika tombol resume ditekan
    if (_timer != null && !_timer.isActive) {
      setState(() {
        _isActive = true;
        _seconds = _remainingSeconds.toDouble(); //mengubah variable _remainingSeconds menjadi double
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) { //percabangan yang dijalankan jika _seconds > 0, maka detik akan dikurangi 1, _seconds < 0, maka detik akan dihentikan dan state akan diubah menjadi _isActive = false
            _seconds--;
          } else {
            _timer.cancel();
            _isActive = false;
          }
        });
      });
    }
  }

  void _resetTimer() { //method yang akan dijalankan ketika tombol reset ditekan
    if (_timer != null) {
      _timer.cancel();
    }
    setState(() {
      _seconds = 0;
      _isActive = false;
    });
  }

  String get _remainingTime {
    return '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}'; //method getter yang akan mengembalikan jumlah detik yang tersisa dalam format mm:ss
  }
}
