import 'package:child_abuse_prevention/src/views/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/background.jpg',
                  opacity: const AlwaysStoppedAnimation(.4),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Text(
                  'Welcome',
                  style: GoogleFonts.poppins(
                      color: Colors.blue.shade900,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Sign In to Continue',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade600),
                      color: Colors.white),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/bd.png',
                          width: 30,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "+88",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            height: 30,
                            child: TextField(
                              controller: mobileCon,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: 'Enter Mobile Number',
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (mobileCon.value.text.isNotEmpty &&
                        mobileCon.value.text.length == 11) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                  number: "+88${mobileCon.value.text}")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid Mobile Number')));
                    }
                  },
                  label: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                      minimumSize:
                          MaterialStateProperty.all(Size(double.infinity, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue.shade700)),
                  icon: const Icon(Icons.keyboard_arrow_right),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'An Otp will be sent to your mobile',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
