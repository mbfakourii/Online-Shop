import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/image_show.dart';

class SelectPicture extends StatefulWidget {
  const SelectPicture({Key? key, required this.image}) : super(key: key);
  final ValueNotifier<File> image;

  @override
  _SelectPictureState createState() => _SelectPictureState();
}

class _SelectPictureState extends State<SelectPicture> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: percentH(context, 0.30),
      child: Card(
        child: Stack(
          children: [
            Center(
              child: ImageShow(widget.image.value.path, fit: BoxFit.fitWidth),
            ),
            Container(
              width: percentW(context, 0.3),
              margin: EdgeInsets.only(top: percentH(context, 0.22)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.white, // Button color
                        child: InkWell(
                          splashColor: Colors.green, // Splash color
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);

                            if (result != null) {
                              File file = File(result.files.single.path!);
                              widget.image.value = file;
                              setState(() {});
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(widget.image.value.path != ""
                                ? Icons.edit
                                : Icons.add),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.white, // Button color
                        child: InkWell(
                          splashColor: Colors.green, // Splash color
                          onTap: () {
                            setState(() {
                              widget.image.value = File("");
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.delete),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
