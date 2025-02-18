import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/post_detail_page.dart';
import 'package:upoint/widgets/custom_loading2.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final OrganizerModel? organizer;
  final String hero;
  final bool isOrganizer;
  final UserModel? user;
  const PostCard({
    super.key,
    required this.post,
    required this.hero,
    required this.isOrganizer,
    required this.organizer,
    required this.user,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    isOver = (widget.post.endDateTime as Timestamp)
        .toDate()
        .isBefore(DateTime.now());
  }

  late bool isOver;
  @override
  Widget build(BuildContext context) {
    informList = [
      {
        "type": "front",
        "icon": Icons.calendar_month,
        "text": TimeTransfer.timeTrans05(
          widget.post.startDateTime,
          widget.post.endDateTime,
        ),
      },
      {
        "type": "front",
        "icon": Icons.local_play,
        "text": widget.post.reward,
      },
    ];
    CColor cColor = CColor.of(context);
    return GestureDetector(
      onTapUp: (d) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              post: widget.post,
              hero: widget.hero,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cColor.card,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height2 * 6,
          horizontal: Dimensions.width2 * 6,
        ),
        child: postCard(
          widget.post.photo,
          widget.post.title,
          widget.post.organizerName,
          widget.post.startDateTime,
          widget.post.endDateTime,
        ),
      ),
    );
  }

  Widget postCard(
    imageUrl,
    title,
    organizerName,
    Timestamp startTime,
    Timestamp endTime,
  ) {
    CColor cColor = CColor.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: ((context, imageProvider) {
            return Hero(
              transitionOnUserGestures: true,
              tag: widget.hero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          placeholder: (context, url) => SizedBox(
            height: Dimensions.height5 * 3,
            width: Dimensions.height5 * 3,
            child:  CustomLoadong2(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        SizedBox(height: Dimensions.height2 * 5),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題
              MediumText(
                color: cColor.grey500,
                size: 14,
                text: title,
                maxLines: 2,
              ),
              // 時間 地點 獎勵
              for (var inform in informList)
                Row(
                  children: [
                    Icon(
                      inform["icon"],
                      size: Dimensions.height2 * 9,
                      color: cColor.grey400,
                    ),
                    SizedBox(width: Dimensions.width2 * 4),
                    SizedBox(
                      width: Dimensions.width2 * 65,
                      child: MediumText(
                        color: cColor.grey500,
                        size: 13,
                        text: inform["text"] ?? "無",
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  late List<Map> informList = [
    {
      "type": "front",
      "icon": Icons.calendar_month,
      "text": TimeTransfer.timeTrans05(
        widget.post.startDateTime,
        widget.post.endDateTime,
      ),
    },
    {
      "type": "front",
      "icon": Icons.location_on,
      "text": widget.post.location,
    },
    {
      "type": "front",
      "icon": Icons.local_play,
      "text": widget.post.reward,
    },
  ];
}
