import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/privo_blogs.dart';
import 'package:privo/app/models/razorpay_order_model.dart';

import 'base_repository.dart';

class KnowledgeBaseRepository extends BaseRepository {
  Future<PrivoBlogs> getBlogs() async {
    ApiResponse apiResponse = await HttpClient.get(
        url: "https://creditsaison.in/wp/wp-json/wp/v2/posts?per_page=10",
        authType: AuthType.none);
    return privoBlogModelFromJson(apiResponse);
  }
}
