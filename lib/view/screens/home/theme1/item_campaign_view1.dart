import 'package:appmartbduser/controller/campaign_controller.dart';
import 'package:appmartbduser/controller/item_controller.dart';
import 'package:appmartbduser/controller/splash_controller.dart';
import 'package:appmartbduser/helper/route_helper.dart';
import 'package:appmartbduser/util/dimensions.dart';
import 'package:appmartbduser/view/base/custom_image.dart';
import 'package:appmartbduser/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class ItemCampaignView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(builder: (campaignController) {
      return (campaignController.itemCampaignList != null && campaignController.itemCampaignList.length == 0) ? SizedBox() : Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(title: 'campaigns'.tr, onTap: () => Get.toNamed(RouteHelper.getItemCampaignRoute())),
          ),

          SizedBox(
            height: 150,
            child: campaignController.itemCampaignList != null ? ListView.builder(
              controller: ScrollController(),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
              itemCount: campaignController.itemCampaignList.length > 10 ? 10 : campaignController.itemCampaignList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      Get.find<ItemController>().navigateToItemPage(campaignController.itemCampaignList[index], context, isCampaign: true);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}'
                            '/${campaignController.itemCampaignList[index].image}',
                        height: 150, width: 150, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ) : ItemCampaignShimmer(campaignController: campaignController),
          ),
        ],
      );
    });
  }
}

class ItemCampaignShimmer extends StatelessWidget {
  final CampaignController campaignController;
  ItemCampaignShimmer({@required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: campaignController.itemCampaignList == null,
            child: Container(
              height: 150, width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }
}

