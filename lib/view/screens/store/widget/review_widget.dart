import 'package:appmartbduser/controller/splash_controller.dart';
import 'package:appmartbduser/data/model/response/review_model.dart';
import 'package:appmartbduser/helper/responsive_helper.dart';
import 'package:appmartbduser/util/dimensions.dart';
import 'package:appmartbduser/util/styles.dart';
import 'package:appmartbduser/view/base/custom_image.dart';
import 'package:appmartbduser/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appmartbduser/view/screens/store/widget/review_dialog.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  ReviewWidget({@required this.review, @required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.dialog(ReviewDialog(review: review)),
      child: Column(children: [

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(
            child: CustomImage(
              image: '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${review.itemImage ?? ''}',
              height: 60, width: 60, fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              review.itemName, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),

            RatingBar(rating: review.rating.toDouble(), ratingCount: null, size: 15),

            Text(
              review.customerName ?? '',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
            ),

            Text(
              review.comment, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            ),

          ])),

        ]),

        (hasDivider && ResponsiveHelper.isMobile(context)) ? Padding(
          padding: EdgeInsets.only(left: 70),
          child: Divider(color: Theme.of(context).disabledColor),
        ) : SizedBox(),

      ]),
    );
  }
}
