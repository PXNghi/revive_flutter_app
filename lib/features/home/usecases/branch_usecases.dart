import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/home/models/branch.dart';

class BranchUsecases {
  static final BranchUsecases _singleton = BranchUsecases._internal();
  
  factory BranchUsecases() => _singleton;
  
  BranchUsecases._internal();

  Future<List<Branch>> getAllBranches() async {
    final Response response = await ApiService().get(ApiUrls().apiGetAllBranches());
    final Map<String, dynamic> data = json.decode(response.body);
    return (data['data'] as List).map((e) => Branch.fromJson(e)).toList();
  }
}