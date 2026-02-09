import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/skeletons/skeletons.dart';

enum SkeletonLoadingType {
  home,
  primaryHomeScreenCard,
  secondaryHomeScreenCard,
  offer,
  creditLine,
  withdrawal,
  homeBottom,
  withdrawalBottom,
  personalDetails,
  workDetails,
  featuredBlog,
  faq
}

///generic loading indicator
///the indicator changes its style with respective
///to [skeletonLoadingType] enum
class SkeletonLoadingWidget extends StatelessWidget {
  const SkeletonLoadingWidget({
    Key? key,
    this.skeletonLoadingType = SkeletonLoadingType.home,
  }) : super(key: key);

  final SkeletonLoadingType skeletonLoadingType;

  @override
  Widget build(BuildContext context) {
    switch (skeletonLoadingType) {
      case SkeletonLoadingType.home:
        return const _HomePageLoadingWidget();
      case SkeletonLoadingType.offer:
        return const _OfferPageLoadingWidget();
      case SkeletonLoadingType.creditLine:
        return const _CreditLineLoadingWidget();
      case SkeletonLoadingType.withdrawal:
        return const _WithdrawLoadingWidget();
      case SkeletonLoadingType.homeBottom:
        return const _HomeBottomLoadingWidget();
      case SkeletonLoadingType.withdrawalBottom:
        return const _HomePageBottomWithdrawalLoadingWidget();
      case SkeletonLoadingType.personalDetails:
        return const _PersonalDetailsLoadingWidget();
      case SkeletonLoadingType.workDetails:
        return const _WorkDetailsLoadingWidget();
      case SkeletonLoadingType.featuredBlog:
        return const _FeaturedBlogLoadingWidget();
      case SkeletonLoadingType.primaryHomeScreenCard:
        return const _HomeScreenLoadingWidget();
      case SkeletonLoadingType.secondaryHomeScreenCard:
        return const _HomeScreenLoadingWidget(
          height: 80,
        );
      case SkeletonLoadingType.faq:
        return const _FAQLoadingWidget();
    }
  }
}

BorderRadius get _skeletonLineBorder => BorderRadius.circular(8);

class _FeaturedBlogLoadingWidget extends StatelessWidget {
  const _FeaturedBlogLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAvatar(
      style: SkeletonAvatarStyle(
          width: double.infinity,
          height: 200,
          borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _HomeScreenLoadingWidget extends StatelessWidget {
  const _HomeScreenLoadingWidget({
    Key? key,
    this.height = 100,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SkeletonAvatar(
      style: SkeletonAvatarStyle(
          width: double.infinity,
          height: height,
          borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _InfoLoadingWidget extends StatelessWidget {
  const _InfoLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SkeletonAvatar(
          style: SkeletonAvatarStyle(
            shape: BoxShape.circle,
            width: 20,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 5,
                  borderRadius: _skeletonLineBorder,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 5,
                  borderRadius: _skeletonLineBorder,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomePageLoadingWidget extends StatelessWidget {
  const _HomePageLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: SkeletonItem(
        child: Column(
          children: [
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 2,
                lineStyle: SkeletonLineStyle(
                  randomLength: true,
                  height: 15,
                  borderRadius: _skeletonLineBorder,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 1,
                spacing: 6,
                lineStyle: SkeletonLineStyle(
                  height: 10,
                  borderRadius: _skeletonLineBorder,
                  minLength: Get.width / 6,
                  maxLength: Get.width / 3,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                width: Get.width / 2,
                height: 30,
                alignment: Alignment.center,
                borderRadius: _skeletonLineBorder,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                width: Get.width / 2,
                height: 5,
                alignment: Alignment.center,
                borderRadius: _skeletonLineBorder,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const _InfoLoadingWidget(),
          ],
        ),
      ),
    );
  }
}

class _OfferPageLoadingWidget extends StatelessWidget {
  const _OfferPageLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: SkeletonItem(
        child: Column(
          children: [
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 1,
                lineStyle: SkeletonLineStyle(
                  alignment: Alignment.center,
                  randomLength: true,
                  height: 15,
                  borderRadius: _skeletonLineBorder,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 2,
                spacing: 6,
                lineStyle: SkeletonLineStyle(
                  alignment: Alignment.center,
                  height: 5,
                  borderRadius: _skeletonLineBorder,
                  minLength: Get.width / 6,
                  maxLength: Get.width / 3,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                width: Get.width / 2,
                height: 30,
                alignment: Alignment.center,
                borderRadius: _skeletonLineBorder,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                width: Get.width / 2,
                height: 60,
                alignment: Alignment.center,
                borderRadius: _skeletonLineBorder,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const _InfoLoadingWidget(),
          ],
        ),
      ),
    );
  }
}

class _CreditLineLoadingWidget extends StatelessWidget {
  const _CreditLineLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: SkeletonItem(
        child: Column(
          children: [
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 1,
                lineStyle: SkeletonLineStyle(
                  alignment: Alignment.center,
                  randomLength: true,
                  height: 15,
                  borderRadius: _skeletonLineBorder,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 2,
                spacing: 6,
                lineStyle: SkeletonLineStyle(
                  alignment: Alignment.center,
                  height: 5,
                  borderRadius: _skeletonLineBorder,
                  minLength: Get.width / 6,
                  maxLength: Get.width / 3,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                    height: 90,
                    width: 90,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 5,
                          borderRadius: _skeletonLineBorder,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 15,
                          borderRadius: _skeletonLineBorder,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 5,
                          borderRadius: _skeletonLineBorder,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const _InfoLoadingWidget(),
          ],
        ),
      ),
    );
  }
}

class _WithdrawLoadingWidget extends StatelessWidget {
  const _WithdrawLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
              width: Get.width * 0.6,
              height: 60,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(50),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  shape: BoxShape.circle,
                  height: 90,
                  width: 90,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: List.generate(
                    3,
                    (index) => Column(
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 5,
                            borderRadius: _skeletonLineBorder,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 15,
                            borderRadius: _skeletonLineBorder,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeBottomLoadingWidget extends StatelessWidget {
  const _HomeBottomLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Column(
        children: List.generate(
          4,
          (index) => Row(
            children: [
              const SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  shape: BoxShape.circle,
                  width: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: 5,
                          borderRadius: _skeletonLineBorder,
                          width: Get.width * 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonalDetailsLoadingWidget extends StatelessWidget {
  final int textFieldSkeletonCount;

  const _PersonalDetailsLoadingWidget(
      {Key? key, this.textFieldSkeletonCount = 5})
      : super(key: key);

  Widget _textFieldSkeleton() {
    return Row(
      children: [
        const SkeletonAvatar(
          style: SkeletonAvatarStyle(
            shape: BoxShape.circle,
            width: 30,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                    height: 10,
                    borderRadius: _skeletonLineBorder,
                    width: Get.width * 0.2),
              ),
              const SizedBox(
                height: 10,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                    height: 20,
                    borderRadius: _skeletonLineBorder,
                    width: Get.width * 0.73),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Column(
        children: List.generate(
          textFieldSkeletonCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: _textFieldSkeleton(),
          ),
        ),
      ),
    );
  }
}

class _WorkDetailsLoadingWidget extends _PersonalDetailsLoadingWidget {
  const _WorkDetailsLoadingWidget({Key? key})
      : super(key: key, textFieldSkeletonCount: 4);
}

class _HomePageBottomWithdrawalLoadingWidget extends StatelessWidget {
  const _HomePageBottomWithdrawalLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
      child: SkeletonItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _titleLoader(),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                _cardLoader(),
                const SizedBox(
                  width: 30,
                ),
                _cardLoader()
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            _titleLoader(),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                _documentTitleLoader(),
                const SizedBox(
                  width: 30,
                ),
                _documentTitleLoader()
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded _documentTitleLoader() {
    return Expanded(
      child: SkeletonAvatar(
        style: SkeletonAvatarStyle(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            height: Get.height * 0.04,
            width: Get.width * 0.04),
      ),
    );
  }

  SkeletonLine _titleLoader() {
    return SkeletonLine(
      style: SkeletonLineStyle(
          height: 5, borderRadius: _skeletonLineBorder, width: Get.width * 0.3),
    );
  }

  Expanded _cardLoader() {
    return Expanded(
      child: SkeletonAvatar(
        style: SkeletonAvatarStyle(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            height: Get.height * 0.08,
            width: Get.width * 0.04),
      ),
    );
  }
}

class _FAQLoadingWidget extends StatelessWidget {
  const _FAQLoadingWidget({Key? key}) : super(key: key);

  Widget _faqTileSkeleton() {
    return Row(
      children: [
        const SkeletonAvatar(
          style: SkeletonAvatarStyle(
            shape: BoxShape.circle,
            width: 50,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                    height: 18,
                    borderRadius: _skeletonLineBorder,
                    width: Get.width * 0.5),
              ),
              const SizedBox(
                height: 10,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                    height: 10,
                    borderRadius: _skeletonLineBorder,
                    width: Get.width * 0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: _faqTileSkeleton(),
          ),
        ),
      ),
    );
  }
}
