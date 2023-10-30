import 'dart:io';

import 'package:beautyminder/pages/todo/viewmodel/todo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddTodoPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddTodoPage({
    Key? key,
    required this.selectedDate,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  late DateTime selectedDate;
  TextEditingController cosmeticNameController = TextEditingController();
  String morningOrEvening = 'morning';
  String? imagePath;
git commit -m "🐛 update"

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        imagePath = photo.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final todoViewModel = context.read<TodoViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '할 일 추가',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              todoViewModel.addTodo(
                cosmeticName: cosmeticNameController.text,
                selectedDate: selectedDate,
                morningOrEvening: morningOrEvening,
                imagePath: imagePath,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: cosmeticNameController,
                decoration: const InputDecoration(
                  hintText: '화장품 이름을 입력하세요.',
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                  '선택된 날짜 : ${selectedDate.toLocal().toString().split(' ')[0]}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ),
            const Divider(),
            RadioListTile<String>(
              title: const Text('Morning'),
              value: 'morning',
              groupValue: morningOrEvening,
              onChanged: (value) {
                setState(() {
                  morningOrEvening = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Evening'),
              value: 'evening',
              groupValue: morningOrEvening,
              onChanged: (value) {
                setState(() {
                  morningOrEvening = value!;
                });
              },
            ),
            (imagePath == null)
                ? Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: const Center(
                      child: Text('선택된 이미지가 없습니다.'),
                    ),
                  )
                : Image.file(
                    File(imagePath!),
                    width: 200,
                    height: 200,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('앨범에서 선택하기'),
                ),
                ElevatedButton(
                  onPressed: _takePhoto,
                  child: const Text('카메라로 촬영하기'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
