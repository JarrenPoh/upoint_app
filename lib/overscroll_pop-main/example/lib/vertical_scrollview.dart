import 'package:flutter/material.dart';
import 'package:overscroll_pop/overscroll_pop.dart';
import 'package:overscroll_pop_example/hero_animation_asset.dart';

class VerticalScrollView extends StatelessWidget {
  final ScrollToPopOption scrollToPopOption;
  final DragToPopDirection? dragToPopDirection;

  const VerticalScrollView({
    Key? key,
    this.scrollToPopOption = ScrollToPopOption.start,
    this.dragToPopDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      createRectTween: HeroAnimationAsset.customTweenRect,
      tag: '$scrollToPopOption${dragToPopDirection ?? ''}',
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
              title: Text(
                'Vertical ScrollView',
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          body: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemBuilder: (_, index) => Container(
              height: 160.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: index % 2 == 0 ? Colors.cyanAccent : Colors.orangeAccent,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(scrollToPopOption.toString()),
                  if (dragToPopDirection != null)
                    Text(dragToPopDirection.toString()),
                ],
              ),
            ),
            itemCount: MediaQuery.of(context).size.height ~/ 160.0 + 2,
          ),
        ),
      ),
    );
  }
}
