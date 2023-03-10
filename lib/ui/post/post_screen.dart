import 'package:flutter/material.dart';
import 'package:hakathon_app/logic/localData/shared_pref.dart';
import 'package:hakathon_app/logic/provider/post_provider.dart';
import 'package:hakathon_app/ui/auth/signup_screen.dart';
import 'package:hakathon_app/utils/constant.dart';
import 'package:provider/provider.dart';

import '../shared/edit_widget.dart';
import '../shared/sharing_post.dart';
import '../shared/text_field_custom.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<PostProvider>().getAllPost(
          token: SharedPrefController().getUser().accessToken,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ));
        }),
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          'Posts List',
          style: TextStyle(color: blueColor),
        ),
        centerTitle: true,
      ),
      drawer: Container(
        padding: const EdgeInsets.only(top: 50),
        color: Colors.white,
        width: 200,
        height: double.infinity,
        child: const ListTile(
          title: Text('John Smith'),
          leading: CircleAvatar(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                borderSide: BorderSide.none),
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            builder: (context) => SizedBox(
              child: ContentOfBottomSheet(
                midea: MediaQuery.of(context).size,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: context.watch<PostProvider>().isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : context.watch<PostProvider>().posts.isEmpty
              ? const Center(
                  child: Text(
                  'NO Posts',
                  style: TextStyle(fontSize: 30),
                ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: nameController,
                        onChanged: (value) {
                          context
                              .read<PostProvider>()
                              .searchPost(postName: value);
                        },
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.search),
                            label: const Text('Search'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Consumer<PostProvider>(
                          builder: (context, providerValue, child) =>
                              ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(nameController
                                                .text.isEmpty
                                            ? (providerValue
                                                        .posts[index].image ==
                                                    ""
                                                ? 'https://www.w3schools.com/w3images/avatar2.png'
                                                : providerValue
                                                    .posts[index].image!)
                                            : (providerValue.searchPosts[index]
                                                        .image ==
                                                    ""
                                                ? 'https://www.w3schools.com/w3images/avatar2.png'
                                                : providerValue
                                                    .searchPosts[index]
                                                    .image!))),
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        nameController.text.isEmpty
                                            ? providerValue
                                                .posts[index].user.name
                                            : providerValue
                                                .searchPosts[index].user.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          child: Text(
                                            nameController.text.isEmpty
                                                ? providerValue
                                                    .posts[index].text
                                                : providerValue
                                                    .searchPosts[index].text,
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Builder(builder: (context) {
                                                return PopupMenuButton(
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    size: 20,
                                                  ),
                                                  onSelected: (value) {
                                                    if (value == 0) {
                                                      showModalBottomSheet(
                                                        shape:
                                                            const OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        backgroundColor:
                                                            Colors.white,
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) =>
                                                            SizedBox(
                                                          child:
                                                              ContentOfBottomSheet(
                                                            id: providerValue
                                                                .posts[index]
                                                                .sId,
                                                            isEdit: true,
                                                            postText:
                                                                providerValue
                                                                    .posts[
                                                                        index]
                                                                    .text,
                                                            midea:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    if (value == 1) {
                                                      providerValue.deletePost(
                                                        token:
                                                            SharedPrefController()
                                                                .getUser()
                                                                .accessToken,
                                                        id: providerValue
                                                            .posts[index].sId,
                                                      );
                                                    }
                                                  },
                                                  itemBuilder: (_) => [
                                                    const PopupMenuItem(
                                                      value: 0,
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem(
                                                      child: Text('Delete'),
                                                      value: 1,
                                                    )
                                                  ],
                                                );
                                              }),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          SharingPost(
                                                        id: providerValue
                                                            .posts[index].sId,
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.share,
                                                    size: 20,
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            itemCount: nameController.text.isEmpty
                                ? providerValue.posts.length
                                : providerValue.searchPosts.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
