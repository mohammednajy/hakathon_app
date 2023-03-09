import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/localData/shared_pref.dart';
import 'package:hakathon_app/logic/provider/post_provider.dart';
import 'package:hakathon_app/ui/shared/cutom_button_widget.dart';
import 'package:provider/provider.dart';

class ContentOfBottomSheet extends StatefulWidget {
  const ContentOfBottomSheet({
    this.isEdit = false,
    super.key,
    required this.midea,
    this.id='',
    this.postText = '',
  });
  final bool isEdit;
  final Size midea;
  final String postText;
  final String id;
  @override
  State<ContentOfBottomSheet> createState() => _ContentOfBottomSheetState();
}

class _ContentOfBottomSheetState extends State<ContentOfBottomSheet> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.postText;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          right: 15,
          left: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEdit ? 'Edit Post' : 'Add Post',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(''),
              ],
            ),
            SizedBox(height: widget.midea.height * 0.023),
            MyTextField(
              controller: controller,
              hintText: '',
              obscureText: false,
              keyboardType: TextInputType.text,
              icon: '',
            ),
            SizedBox(height: widget.midea.height * 0.023),
            //---------------------------------------------------------------------------
            !widget.isEdit
                ? Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        // context.read<PostProvider>().pickFile();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Upload your image',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                                'Drag and drop or browse to choose a file',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  })
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xFFF5F5F5),
                          child: Icon(
                            Icons.image,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Upload your image',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
            //----------------------------------------------------------------------------------------
            SizedBox(height: widget.midea.height * 0.023),
            Consumer<PostProvider>(
              builder: (context, value, child) => CustomButtonWidget(
                onPressed: () {
                widget.isEdit? 
                value.editPost(token: SharedPrefController().getUser().accessToken, id: widget.id, text: controller.text)
                :  value.addPost(
                    token: SharedPrefController().getUser().accessToken,
                    postText: controller.text,
                    // file: value.file,
                  );
                },
                isLoading: false,
                text: widget.isEdit ? 'Edit' : 'Add',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
    this.bottomMargin = 0,
    this.prefixIcon,
    this.onChange,
    //this.onSaved,
    this.height = 65,
    this.width = double.infinity,
    this.vertical = 20,
    this.validator,
    required this.controller,
    required this.icon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final bool obscureText;
  double bottomMargin;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  Function? onChange;
  TextEditingController controller;
  AutovalidateMode? autovalidateMode;
  Widget? prefixIcon;
  double height;
  double width;
  double vertical;
  String icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black,
      ),
      onChanged: onChange as Function(String?)?,
      //   onSaved: onSaved as Function(String?)?,
      controller: controller,
      minLines: 4,
      maxLines: 4,
      validator: validator as String? Function(String?)?,
      keyboardType: keyboardType,
      autovalidateMode: autovalidateMode,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        errorStyle: const TextStyle(fontSize: 12, height: 0.3),
        hintStyle: const TextStyle(color: Colors.grey),

        contentPadding:
            EdgeInsets.symmetric(horizontal: 34, vertical: vertical),
        // prefixIcon: SvgPicture.asset(
        //   icon,
        //   fit: BoxFit.scaleDown,
        // ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 1,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
