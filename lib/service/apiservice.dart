import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitlist/models/gitdatamodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<GitData> fetchdata({required page}) async {
  var date = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 30)));
  final response = await http.get(Uri.parse(
      'https://api.github.com/search/repositories?q=created:>$date&sort=stars&order=desc&page=$page&per_page=10'));
  if (response.statusCode == 200) {
    return gitDataFromJson(response.body);
  } else {
    var jsondata = json.decode(response.body);
    throw Exception(jsondata['message']);
  }
}

final itemsdataprovider = StateProvider<List<Item>>((ref) => []);
final intprovider = StateProvider<int>((ref) => 1);
final gitdataresponse = FutureProvider((ref) async {
  int pageno = ref.watch(intprovider);
  final data = await fetchdata(page: pageno);
  ref.read(itemsdataprovider.notifier).update((state) => state + data.items);
  return ref.read(itemsdataprovider);
});
