import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/tab_organizer_body.dart';
import 'package:upoint/widgets/home/tab_reward_body.dart';
import 'package:provider/provider.dart';
import '../firebase/auth_methods.dart';
import '../globals/user_simple_preference.dart';
import '../models/ad_model.dart';
import '../models/post_model.dart';
import '../widgets/home/tab_home_body.dart';
import '../widgets/home/tab_type_body.dart';

class HomePage extends StatefulWidget {
  final Function(int) searchTapped;
  final List<PostModel> allPost;
  final UserModel? user;
  final List<AdModel> allAd;
  const HomePage({
    super.key,
    required this.searchTapped,
    required this.allPost,
    required this.user,
    required this.allAd,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  List tabList = ["UPoint", "單位", "類別", "獎勵"];
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: tabList.length,
      vsync: this,
      initialIndex: 0,
    );
    uploadNewFCM();
  }

  uploadNewFCM() async {
    String? newFcm = UserSimplePreference.getFcmToken();
    if (widget.user != null && newFcm != null) {
      if (widget.user!.fcmToken == null ||
          !widget.user!.fcmToken!.contains(newFcm)) {
        await FirestoreMethods().addFcm(newFcm, widget.user!);
        await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CColor cColor = CColor.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          color: cColor.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: cColor.white,
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        backgroundColor: cColor.white,
                        title: PreferredSize(
                          preferredSize: Size(
                              Dimensions.screenWidth, Dimensions.height5 * 0),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            labelColor: cColor.grey500,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            unselectedLabelColor: cColor.grey300,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                              color: cColor.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            indicatorPadding: EdgeInsets.only(
                              bottom: Dimensions.height2 * 4,
                              top: Dimensions.height2 * 18.5,
                              left: 0,
                              right: 0,
                            ),
                            indicatorWeight: 4,
                            onTap: (value) {
                              tabController.index = value;
                            },
                            controller: tabController,
                            tabs: List.generate(
                              tabList.length,
                              (index) => Tab(
                                child: Text(tabList[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Builder(
                  builder: (context) {
                    return CustomScrollProvider(
                      tabController: tabController,
                      parent: PrimaryScrollController.of(context),
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          TabHomeBody(
                            index: 0,
                            user: widget.user,
                            allPost: widget.allPost,
                            allAd: widget.allAd,
                          ),
                          TabOrganizerBody(
                            index: 1,
                            user: widget.user,
                            allPost: widget.allPost,
                            allAd: widget.allAd,
                          ),
                          TabTypeBody(
                            index: 2,
                            user: widget.user,
                            allPost: widget.allPost,
                            allAd: widget.allAd,
                          ),
                          TabRewardBody(
                            index: 3,
                            user: widget.user,
                            allPost: widget.allPost,
                            allAd: widget.allAd,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  MySliverDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //子Widget布局

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => (maxHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
