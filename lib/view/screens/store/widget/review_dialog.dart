import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appmartbduser/controller/splash_controller.dart';
import 'package:appmartbduser/data/model/response/review_model.dart';
import 'package:appmartbduser/util/dimensions.dart';
import 'package:appmartbduser/util/styles.dart';
import 'package:appmartbduser/view/base/custom_image.dart';
import 'package:appmartbduser/view/base/rating_bar.dart';

class ReviewDialog extends StatelessWidget {
  final ReviewModel review;
  final bool fromOrderDetails;
  const ReviewDialog({@required this.review, this.fromOrderDetails = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: !fromOrderDetails ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

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
              review.comment,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            ),

          ])),

        ]) : Text(
          review.comment,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge.color),
        ),
      )),
    );
  }
}
