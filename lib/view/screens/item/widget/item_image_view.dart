import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appmartbduser/controller/item_controller.dart';
import 'package:appmartbduser/controller/splash_controller.dart';
import 'package:appmartbduser/data/model/response/item_model.dart';
import 'package:appmartbduser/helper/responsive_helper.dart';
import 'package:appmartbduser/helper/route_helper.dart';
import 'package:appmartbduser/util/dimensions.dart';
import 'package:appmartbduser/view/base/custom_image.dart';

class ItemImageView extends StatelessWidget {
  final Item item;
  ItemImageView({@required this.item});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    List<String> _imageList = [];
    _imageList.add(item.image);
    _imageList.addAll(item.images);

    return GetBuilder<ItemController>(
      builder: (itemController) {
        String _baseUrl = item.availableDateStarts == null ? Get.find<SplashController>().
            configModel.baseUrls.itemImageUrl : Get.find<SplashController>().configModel.baseUrls.campaignImageUrl;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                RouteHelper.getItemImagesRoute(item),
                arguments: ItemImageView(item: item),
              ),
              child: Stack(children: [
                SizedBox(
                  height: ResponsiveHelper.isDesktop(context)? 350: MediaQuery.of(context).size.width * 0.7,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _imageList.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomImage(
                          image: '$_baseUrl/${_imageList[index]}',
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      itemController.setImageSliderIndex(index);
                    },
                  ),
                ),
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _indicators(context, itemController, _imageList),
                    ),
                  ),
                ),

              ]),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _indicators(BuildContext context, ItemController itemController, List<String> _imageList) {
    List<Widget> indicators = [];
    for (int index = 0; index < _imageList.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == itemController.imageSliderIndex ? Theme.of(context).primaryColor : Colors.white,
        borderColor: Colors.white,
        size: 10,
      ));
    }
    return indicators;
  }

}
