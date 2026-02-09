import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/privo_blogs.dart';
import 'package:privo/app/modules/blog_details/widgets/is_blog_useful_dialog.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

enum SocialMediaType { facebook, instagram, whatsapp }

class BlogDetailsLogic extends GetxController {
  late Blog blog;
  late List<Blog> recomendedBlogs;
  WebViewControllerPlus webViewPlusController = WebViewControllerPlus();

  late List<SocialMedia> socialMediaData = [
    SocialMedia(
        socialMediaType: SocialMediaType.facebook,
        icon: Res.blogFacebookIcon,
        url: "https://www.facebook.com/sharer/sharer.php?u="),
    SocialMedia(
        socialMediaType: SocialMediaType.instagram,
        icon: Res.blogInstagramIcon,
        url: "https://www.instagram.com/direct/inbox/"),
    SocialMedia(
        socialMediaType: SocialMediaType.whatsapp,
        icon: Res.blogWhatsappIcon,
        url: "https://api.whatsapp.com/send?text="),
  ];

  @override
  void onInit() {
    onWebViewCreated();
    var arguments = Get.arguments;
    if (arguments['blog'] != null) {
      blog = arguments['blog'];
      recomendedBlogs = arguments['recomendedBlogs'];
    }
  }

  void onWebViewCreated() {
    String htmlString = """
   <!DOCTYPE html>
<html>
    <head>
    <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Figtree:wght@400;500;600;700&display=swap" rel="stylesheet">
<meta
      name="viewport"
      content="user-scalable=no, width=device-width"
    />
    </head>
    ${_blogStyle()}
    ${_blogDescriptionBody()}
     </html>
    """;
    Get.log(htmlString);
    webViewPlusController
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlString)
      ..addJavaScriptChannel(
        "BlogEvent",
        onMessageReceived: (blog) {
          _onBlogClickEventRecieved(blog);
        },
      );
  }

  void _onBlogClickEventRecieved(JavaScriptMessage blog) {
    Get.log("Blog recieved ${blog}");
    var selectedblog = recomendedBlogs
        .where(
            (element) => int.parse(element.blogId) == int.parse(blog.message))
        .toList();
    onRecomenddedBlogTapped(selectedblog.first);
  }

  _blogDescriptionBody() {
    return """
        <body>
     <img src="${blog.blogImage}" alt="${blog.blogImage}" width=100%>
    ${blog.blogDescription}
<hr class=“solid” color="#1D478E" style="height: 1.5px;border-width:0;margin-top: 25px;">      
  <div class="suggestion-box">
      <span class="box-subtitle">You may also like</span>
      <div id="rc1" class="suggestion-card" onClick="openBlog('${recomendedBlogs[0].blogId}')">
        <img
          src="${recomendedBlogs[0].blogImage}"
          class="card-image"
          alt="Random Placeholder Image"
        />
        <div class="card-contents">
          <span class="card-title">${recomendedBlogs[0].blogTitle}</span>
          <span class="card-info">${recomendedBlogs[0].blogDate}</span>
        </div>
      </div>
      <div id="rc2" class="suggestion-card" onclick="openBlog('${recomendedBlogs[1].blogId}')">
        <img
          src="${recomendedBlogs[1].blogImage}"
          class="card-image"
          alt="Random Placeholder Image"
        />
        <div class="card-contents">
          <span class="card-title">${recomendedBlogs[1].blogTitle}</span>
          <span class="card-info">${recomendedBlogs[1].blogDate}</span>
        </div>
      </div>
    </div>
    
      <script>
    function openBlog(blog){
    console.log("Blog");
    BlogEvent.postMessage(blog);
    }
    </script>
    </body>
    """;
  }

  _blogStyle() {
    return """
     <style>
         body {
                font-family: 'Figtree', sans-serif;
                color: #1D478E;
                font-size: 12px;
            }
            h1 {
                color: #1D478E;
                font-size: 14px;
                font-weight: 700;
                padding:0;
                margin:0;
            }
            h2 {
                color: #1D478E;
                font-size: 14px;
                font-weight: 700;
                padding:0;
                margin:0;
            }
            h3 {
              color: #1D478E;
                font-size: 14px;
                font-weight: 700;
                padding:0;
                margin:0.2px;
            }
             p {
                color: #1D478E;
                font-size: 12px;
                font-weight: 400;
                padding:0;
                margin:1px;
            }
             .box-subtitle {
        display: block;
        color: #1d478e;
        font-family: 'Figtree', sans-serif;
        font-size: 12px;
        font-weight: 700;
        margin-bottom: 12px;
      }

      .suggestion-card {
        display: flex;
        border-radius: 8px;
        border: 0.2px solid #1d478e;
        background: #fff;
        box-shadow: 0px 0px 2px 0px rgba(0, 0, 0, 0.16);
        margin-bottom: 16px;
        overflow: hidden;
        max-width: 300px;
        height: 80px;
      }

      .card-image {
        width: 100px;
        height: 100%;
      }

      .card-contents {
        padding: 12px;
        display: flex;
        flex-direction: column;
      }

      .card-title {
        color: #1d478e;
        font-family: 'Figtree', sans-serif;
        font-size: 12px;
        font-weight: 600;
        line-height: 140%; /* 16.8px */
      }

      .card-info {
        color: #1d478e;
        font-family: 'Figtree', sans-serif;
        font-size: 8px;
        font-weight: 400;
        line-height: 140%; /* 16.8px */
        margin-top: 6px;
      }
        </style>
    """;
  }

  void onRecomenddedBlogTapped(Blog selectedBlog) {
    recomendedBlogs = [
      blog,
      recomendedBlogs.where((element) => element != selectedBlog).toList().first
    ];
    blog = selectedBlog;

    onWebViewCreated();
    update();
  }

  void onCloseTapped() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.blogClosed);
    if (Get.context != null) {
      await showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => IsBlogUseFulDialog(),
      );
      Get.back();
    }
  }
}

class SocialMedia {
  SocialMediaType socialMediaType;
  String icon;
  String url;

  SocialMedia(
      {required this.socialMediaType, required this.icon, required this.url});
}
