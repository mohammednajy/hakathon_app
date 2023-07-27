import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hakathon_app/api/app_exception.dart';
import 'package:hakathon_app/logic/localData/shared_pref.dart';
import 'package:hakathon_app/logic/models/post_model.dart';
import 'package:hakathon_app/logic/provider/post_provider.dart';
import 'package:hakathon_app/ui/shared/edit_widget.dart';
import 'package:hakathon_app/ui/shared/sharing_post.dart';
import 'package:hakathon_app/utils/constant.dart';
import 'package:hakathon_app/utils/helper.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController nameController = TextEditingController();
  late ScrollController scrollController;
  late Future<List<PostModel>> posts;

  @override
  void initState() {
    super.initState();
    posts = Provider.of<PostProvider>(context, listen: false).getAllPost(
      token: SharedPrefController().getUser().accessToken,
    );

    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    nameController.dispose();
    scrollController.removeListener(loadMore);
    super.dispose();
  }

  loadMore() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      context.read<PostProvider>().loadMore(
            token: SharedPrefController().getUser().accessToken,
          );
    }
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
        actions: [
          IconButton(
            onPressed: () {
              context.read<PostProvider>().logout();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
          )
        ],
      ),
      drawer: Container(
        padding: const EdgeInsets.only(top: 50),
        color: Colors.white,
        width: 200,
        height: double.infinity,
        child: ListTile(
          title: Text(SharedPrefController().getUser().data.name),
          leading: const CircleAvatar(
            backgroundImage:
                NetworkImage('https://www.w3schools.com/w3images/avatar2.png'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PostProvider>().cancelImage();
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
                      context.read<PostProvider>().searchPost(postName: value);
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
                  FutureBuilder<List<PostModel>>(
                      future: posts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          if (snapshot.error.runtimeType == DioError) {
                            final errorMessage = DioExceptions.fromDioError(
                                snapshot.error as DioError);
                            return UtilsConfig.showSnackBarMessage(
                                message: errorMessage, status: false);
                          }
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Text(
                              'NO Posts',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            );
                          }

                          List<PostModel> postsList = snapshot.data!;
                          return Expanded(
                            child: Consumer<PostProvider>(
                              builder: (context, providerValue, child) =>
                                  ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius: 25,
                                                backgroundImage: nameController
                                                        .text.isEmpty
                                                    ? (postsList[index].image !=
                                                            ""
                                                        ? NetworkImage(
                                                            postsList[index]
                                                                .image!)
                                                        : null)
                                                    : providerValue
                                                                .searchPosts[
                                                                    index]
                                                                .image !=
                                                            ""
                                                        ? NetworkImage(
                                                            providerValue
                                                                .searchPosts[
                                                                    index]
                                                                .image!)
                                                        : null,
                                                child: nameController
                                                        .text.isEmpty
                                                    ? (postsList[index].image ==
                                                            ""
                                                        ? const Icon(
                                                            Icons.image)
                                                        : null)
                                                    : providerValue
                                                                .searchPosts[index]
                                                                .image ==
                                                            ""
                                                        ? const Icon(Icons.image)
                                                        : null),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Text(
                                                nameController.text.isEmpty
                                                    ? postsList[index].user.name
                                                    : providerValue
                                                        .searchPosts[index]
                                                        .user
                                                        .name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 6,
                                                  child: Text(
                                                    nameController.text.isEmpty
                                                        ? postsList[index].text
                                                        : providerValue
                                                            .searchPosts[index]
                                                            .text,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Builder(
                                                          builder: (context) {
                                                        return PopupMenuButton(
                                                          icon: const Icon(
                                                            Icons.more_vert,
                                                            size: 20,
                                                          ),
                                                          onSelected: (value) {
                                                            if (value == 0) {
                                                              providerValue
                                                                  .cancelImage();
                                                              showModalBottomSheet(
                                                                shape:
                                                                    const OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .only(
                                                                          topLeft:
                                                                              Radius.circular(15),
                                                                          topRight:
                                                                              Radius.circular(15),
                                                                        ),
                                                                        borderSide:
                                                                            BorderSide.none),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                builder:
                                                                    (context) =>
                                                                        SizedBox(
                                                                  child:
                                                                      ContentOfBottomSheet(
                                                                    image: providerValue
                                                                            .posts[index]
                                                                            .image ??
                                                                        '',
                                                                    id: providerValue
                                                                        .posts[
                                                                            index]
                                                                        .sId,
                                                                    isEdit:
                                                                        true,
                                                                    postText: providerValue
                                                                        .posts[
                                                                            index]
                                                                        .text,
                                                                    midea: MediaQuery.of(
                                                                            context)
                                                                        .size,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            if (value == 1) {
                                                              providerValue
                                                                  .deletePost(
                                                                token: SharedPrefController()
                                                                    .getUser()
                                                                    .accessToken,
                                                                id: providerValue
                                                                    .posts[
                                                                        index]
                                                                    .sId,
                                                              );
                                                            }
                                                          },
                                                          itemBuilder: (_) => [
                                                            const PopupMenuItem(
                                                              value: 0,
                                                              child:
                                                                  Text('Edit'),
                                                            ),
                                                            const PopupMenuItem(
                                                              value: 1,
                                                              child: Text(
                                                                  'Delete'),
                                                            )
                                                          ],
                                                        );
                                                      }),
                                                      SharedPrefController()
                                                                  .getUser()
                                                                  .data
                                                                  .sId ==
                                                              providerValue
                                                                  .posts[index]
                                                                  .user
                                                                  .sId
                                                          ? IconButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      SharingPost(
                                                                    id: providerValue
                                                                        .posts[
                                                                            index]
                                                                        .sId,
                                                                  ),
                                                                );
                                                              },
                                                              icon: const Icon(
                                                                Icons.share,
                                                                size: 20,
                                                              ))
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                    if (providerValue.isLoadMoreRunning ==
                                            true &&
                                        index == providerValue.posts.length - 1)
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      ),
                                  ],
                                ),
                                itemCount: nameController.text.isEmpty
                                    ? providerValue.posts.length
                                    : providerValue.searchPosts.length,
                              ),
                            ),
                          );
                        }
                        return Text('Something wrong');
                      }),
                  if (context.watch<PostProvider>().hasNextPage == false)
                    const Center(
                      child: Text(
                        'End of posts',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
