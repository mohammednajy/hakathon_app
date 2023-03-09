import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/localData/shared_pref.dart';
import 'package:hakathon_app/logic/provider/post_provider.dart';
import 'package:hakathon_app/ui/shared/text_field_custom.dart';
import 'package:provider/provider.dart';

import '../../utils/constant.dart';

enum viewer { ViewedOnly, ViewedOnlyAndEdit }

class SharingPost extends StatefulWidget {
  const SharingPost({
    super.key, required this.id,
  });
final String id;
  @override
  State<SharingPost> createState() => _SharingPostState();
}

class _SharingPostState extends State<SharingPost> {
  viewer? _viewer = viewer.ViewedOnly;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      title: const Text(
        'Share post',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.all(15),
      content: SizedBox(
        height: 160,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFieldCustom(
                controller: textEditingController,
                labelText: 'Email',
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'General access',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Viewed only',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              value: viewer.ViewedOnly,
                              groupValue: _viewer,
                              onChanged: (viewer? value) {
                                setState(() {
                                  _viewer = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Viewed and edit',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              value: viewer.ViewedOnlyAndEdit,
                              groupValue: _viewer,
                              onChanged: (viewer? value) {
                                setState(() {
                                  _viewer = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            side: const BorderSide(
              color: blueColor,
            ),
          ),
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<PostProvider>().sharePost(
                  id: widget.id,
                  token: SharedPrefController().getUser().accessToken,
                  email: textEditingController.text,
                  permission: _viewer == viewer.ViewedOnly ? "read" : "write",
                );
          },
          style: ElevatedButton.styleFrom(
            primary: blueColor,
          ),
          child: const Text('Share'),
        )
      ],
    );
  }
}
