// ignore_for_file: unused_element, use_build_context_synchronously

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_car/services/services.dart';
import 'package:love_car/src/global/global.dart';
import 'package:love_car/src/pages/buy_and_sell/domain/models/models.dart';

class CarPostCard extends HookConsumerWidget {
  const CarPostCard(
    this.data, {
    required this.onClicked,
    required this.onLikeClicked,
    required this.onPhoneClicked,
    required this.onChatClicked,
    super.key,
  });
  final CarPost data;
  final void Function() onClicked;
  final void Function() onLikeClicked;
  final void Function() onPhoneClicked;
  final void Function() onChatClicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = useState<CarPost>(data);
    useListenable(dataAsync);

    useEffect(() {
      return null;
    }, [dataAsync]);

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.black,
            child: InkWell(
              onTap: onClicked,
              overlayColor: WidgetStatePropertyAll(
                context.bgColor.withAlpha((0.4 * 255).toInt()),
              ),
              borderRadius: BorderRadius.circular(10),
              child: Ink(
                width: double.infinity,
                height: 185,
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 230,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: data.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CupertinoBtn(
                        color: themeColor.withAlpha((0.4 * 255).toInt()),
                        padding: EdgeInsets.all(5),
                        borderRadius: BorderRadius.circular(100),
                        onPressed: onLikeClicked,
                        child: Icon(
                          data.isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 24,
                          color: themeColor,
                        ),
                      ),
                    ),
                    if (!data.isAvailable)
                      Positioned(
                        top: 15,
                        left: -32,
                        child: Transform.rotate(
                          angle: -pi / 4,
                          child: Container(
                            width: 120,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'SOLD OUT',
                              overflow: TextOverflow.ellipsis,
                              style: body.textColor(Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.black,
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClicked,
                  overlayColor: WidgetStatePropertyAll(
                    Colors.white.withAlpha((0.1 * 255).toInt()),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    width: double.infinity,
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((0.5 * 255).toInt()),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              Text(
                                '${data.brandName} • ${data.modelName} (${data.manufacturingYear})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: loginTextStyle.semiBold
                                    .textColor(Colors.white),
                              ),
                              Text(
                                data.price == 'Negotiation'
                                    ? 'ညှိနှိုင်း'
                                    : '${data.price} Lakh',
                                style: large.bold.textColor(Colors.white),
                              ),
                              Text(
                                dateFormat(data.date),
                                style: body.textColor(
                                  Colors.white.withAlpha((0.7 * 255).toInt()),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data.viewsCount.format,
                                    style: body.textColor(Colors.white),
                                  ),
                                  5.hGap,
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: onPhoneClicked,
                                    borderRadius: BorderRadius.circular(100),
                                    overlayColor: WidgetStatePropertyAll(
                                      context.bgColor
                                          .withAlpha((0.4 * 255).toInt()),
                                    ),
                                    child: Ink(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.phone,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  10.hGap,
                                  InkWell(
                                    onTap: onChatClicked,
                                    borderRadius: BorderRadius.circular(100),
                                    overlayColor: WidgetStatePropertyAll(
                                      context.bgColor
                                          .withAlpha((0.4 * 255).toInt()),
                                    ),
                                    child: Ink(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.chat_bubble_fill,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
