import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitlist/service/apiservice.dart';
import 'package:intl/intl.dart';

import '../models/gitdatamodel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ScrollController scrollConstroller = ScrollController();
  // int pageno = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollConstroller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollConstroller.position.pixels - 200 ==
        scrollConstroller.position.maxScrollExtent - 200) {
      var pageno = ref.watch(intprovider);
      pageno < 100 ? ref.read(intprovider.notifier).state = pageno + 1 : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gitdataresponse);
    List<Item> data = ref.watch(itemsdataprovider);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text('Git Top Repos')),
            body: ListView.builder(
              padding: EdgeInsets.all(12.0),
              controller: scrollConstroller,
              itemCount: data.length,
              itemBuilder: (context, index) {
                Item itemdata = data[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    child: ListTile(
                      title: Text(toBeginningOfSentenceCase(itemdata.name)!),
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(itemdata.owner.avatarUrl)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemdata.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('Owned By : ${itemdata.owner.login}')
                        ],
                      ),
                      trailing: Column(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          Text(itemdata.stargazersCount.toString())
                        ],
                      ),
                    ),
                  ),
                );
              },
            )

            // gitdata.when(
            //     data: (data) {
            //       // ref.read(itemsdataprovider.notifier).state = itemsdata + data.items;
            //       return ListView.builder(
            //         padding: EdgeInsets.all(12.0),
            //         controller: scrollConstroller,
            //         itemCount: data.length,
            //         itemBuilder: (context, index) {
            //           Item itemdata = data[index];
            //           return Padding(
            //             padding: const EdgeInsets.all(5.0),
            //             child: Card(
            //               elevation: 2,
            //               color: Colors.white,
            //               child: ListTile(
            //                 title: Text(toBeginningOfSentenceCase(itemdata.name)!),
            //                 leading: CircleAvatar(
            //                     backgroundImage:
            //                         NetworkImage(itemdata.owner.avatarUrl)),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //     error: (error, stackTrace) => Center(
            //             child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(error.toString()),
            //         )),
            //     loading: () => ref.read(itemsdataprovider).isEmpty
            //         ? Center(
            //             child: CircularProgressIndicator(),
            //           )
            //         : null),
            ));
  }
}
