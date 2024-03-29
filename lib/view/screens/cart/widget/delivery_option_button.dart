import 'package:appmartbduser/controller/order_controller.dart';
import 'package:appmartbduser/helper/price_converter.dart';
import 'package:appmartbduser/util/dimensions.dart';
import 'package:appmartbduser/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final double charge;
  final bool isFree;
  DeliveryOptionButton({@required this.value, @required this.title, @required this.charge, @required this.isFree});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return InkWell(
          onTap: () => orderController.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: orderController.orderType,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (String value) => orderController.setOrderType(value),
                activeColor: Theme.of(context).primaryColor,
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Text(title, style: robotoRegular),
              SizedBox(width: 5),

              Text(
                '(${(value == 'take_away' || isFree) ? 'free'.tr : charge != -1 ? PriceConverter.convertPrice(charge) : 'calculating'.tr})',
                style: robotoMedium,
              ),

            ],
          ),
        );
      },
    );
  }
}
