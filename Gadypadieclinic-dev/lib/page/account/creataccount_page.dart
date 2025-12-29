import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final titleController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  DateTime? selectedDate;
  String selectedGender = 'Gender';
  bool showPassword = false;

  Future<void> _registerUserAndSaveToFirestore() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'title': titleController.text.trim(),
        'firstname': firstNameController.text.trim(),
        'lastname': lastNameController.text.trim(),
        'dob': selectedDate != null
    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
    : null,
        'gender': selectedGender,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildLabel(String label) => Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 6.0),
        child: Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 88, 88, 88))),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE49092), Color(0xFFEBE6E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFFEBE6E0),
          elevation: 0,
          centerTitle: true,
          title: Image.asset('assets/image/logo.png', height: 40),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2),
            child: Container(color: Color(0xFFBDB3A7), height: 2),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF9C9389)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("LOGIN INFORMATION",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildLabel("E-mail *"),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail *",
                    hintStyle: TextStyle(
                      color: Color(0xFFBDB3A7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFBDB3A7), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFE49092), width: 1.8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                _buildLabel("Phone Number *"),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "Phone Number *",
                    hintStyle: TextStyle(
                      color: Color(0xFFBDB3A7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFBDB3A7), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFE49092), width: 1.8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Phone number must be numeric';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                _buildLabel("Password *"),
                TextFormField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: "Password *",
                    hintStyle: TextStyle(
                      color: Color(0xFFBDB3A7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFBDB3A7), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFE49092), width: 1.8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => showPassword = !showPassword),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                ),
                SizedBox(height: 20),
                Text("PERSONAL INFORMATION",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildLabel("Title *"),
                DropdownButtonFormField<String>(
                  value: titleController.text.isNotEmpty
                      ? titleController.text
                      : null,
                  decoration: InputDecoration(
                    hintText: "Select Title",
                    hintStyle: TextStyle(
                      color: Color(0xFFBDB3A7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFBDB3A7), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFE49092), width: 1.8),
                    ),
                  ),
                  items: ['Mr.', 'Mrs.', 'Miss']
                      .map((title) => DropdownMenuItem<String>(
                            value: title,
                            child: Text(title),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      titleController.text = value!;
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select your title'
                      : null,
                ),
                _buildLabel("First Name *"),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: "First Name *",
                    hintStyle: TextStyle(
                      color: Color(0xFFBDB3A7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFBDB3A7), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFE49092), width: 1.8),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your first name' : null,
                ),
                _buildLabel("Last Name *"),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: "Last Name *",
                    hintStyle: TextStyle(
                      color: Color(0xFFBDB3A7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFBDB3A7), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Color(0xFFE49092), width: 1.8),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your last name' : null,
                ),
                _buildLabel("Date of Birth"),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFFBDB3A7)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : '${selectedDate!.toLocal()}'.split(' ')[0],
                      style: TextStyle(
                          fontSize: 16,
                          color: selectedDate == null
                              ? Color(0xFFBDB3A7)
                              : Color(0xFFBDB3A7)),
                    ),
                  ),
                ),
                _buildLabel("Gender"),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFBDB3A7)),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    value: selectedGender,
                    isExpanded: true,
                    underline: SizedBox(),
                    style: TextStyle(
                      color: Color(0xFFBDB3A7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                    items: ['Gender', 'Male', 'Female', 'Other'].map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9C9389),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _registerUserAndSaveToFirestore();
                      }
                    },
                    child: Text("CREATE AN ACCOUNT",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
