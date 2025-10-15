import 'package:cached_network_image/cached_network_image.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_car/services/services.dart';
import 'package:love_car/src/global/global.dart';
import 'package:love_car/src/pages/buy_and_sell/presentation/components/components.dart';
import 'package:love_car/src/pages/coin/coin_scanner/application/services/user_shop_service.dart';
import 'package:love_car/src/pages/coin/coin_scanner/domain/models/models.dart';
import 'package:love_car/src/pages/login/application/services/user_service.dart';

class FilterComponent extends HookConsumerWidget {
  const FilterComponent(this.filterData,
      {required this.onConfirmed, super.key});
  final Map<String, dynamic>? filterData;
  final void Function(Map<String, dynamic>?) onConfirmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userServiceProvider).value;
    final service = ref.watch(userShopServiceProvider(user?.id ?? 0));
    final selectedShowRoomId = useState<int>(0);
    final _filterData = useState<Map<String, dynamic>?>(filterData);
    useListenable(_filterData);

    void updateFilter() {
      _filterData.value = {
        ...?_filterData.value,
        // 'show_room_id':
        //     selectedShowRoomId.value > 0 ? selectedShowRoomId.value : null,
      }..removeWhere((key, value) => value == null);
    }

    useEffect(() {
      final filters = _filterData.value;
      if (filters == null) return null;
      if (filters.containsKey('show_room_id')) {
        selectedShowRoomId.value =
            int.parse(filters['show_room_id'].toString());
      }
      return null;
    }, [_filterData.value]);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: service.when(
              data: (data) {
                final allShowRooms = UserShop(id: 0, code: '', name: 'All');
                final showRooms = [allShowRooms, ...data];
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SeparatedRow(
                    padding: EdgeInsets.only(left: 10),
                    separatorBuilder: () => 3.hGap,
                    children: showRooms.asMap().entries.map((e) {
                      if (e.key == 0) {
                        return CustomAnimatedButton.text(
                          title: e.value.name,
                          isActive: e.value.id == selectedShowRoomId.value,
                          onTap: (isActive) {
                            if (isActive) return;
                            selectedShowRoomId.value = e.value.id;
                            updateFilter();
                            onConfirmed(_filterData.value);
                          },
                        );
                      } else {
                        return CustomAnimatedButton(
                          'http://testing.lovecar.autos/storage/68a33ec08b48b_1755528896.jpg',
                          title: e.value.name,
                          isActive: e.value.id == selectedShowRoomId.value,
                          onTap: (isActive) {
                            if (isActive) return;
                            selectedShowRoomId.value = e.value.id;
                            updateFilter();
                            onConfirmed(_filterData.value);
                          },
                        );
                      }
                    }).toList(),
                  ),
                );
              },
              error: (e, s) => SizedBox.shrink(),
              loading: () => Center(
                child: LinearProgressIndicator(
                  backgroundColor: context.bgColor,
                  color: themeColor,
                ),
              ),
            ),
          ),
          5.hGap,
          Stack(
            children: [
              CupertinoBtn(
                // color: const Color(0xff7360F2),
                color: context.cardColor,
                padding: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(100),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => FilterBottomSheet(
                    _filterData.value,
                    onConfirmed: (v) {
                      _filterData.value = v;
                      updateFilter();
                      onConfirmed(_filterData.value);
                    },
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/svg/filter-search.svg',
                  height: 20,
                  fit: BoxFit.fitHeight,
                  color: context.iconColor,
                ),
              ),
              if (_filterData.value?.isNotEmpty ?? false)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
          5.hGap,
        ],
      ),
    );
  }
}

class CustomAnimatedButton extends HookWidget {
  const CustomAnimatedButton(
    this.logo, {
    required this.title,
    required this.onTap,
    required this.isActive,
    super.key,
  }) : isTextBtn = false;
  const CustomAnimatedButton.text({
    required this.title,
    required this.onTap,
    required this.isActive,
    super.key,
  })  : logo = '',
        isTextBtn = true;

  final String logo;
  final String title;
  final ValueChanged<bool> onTap;
  final bool isActive;
  final bool isTextBtn;

  @override
  Widget build(BuildContext context) {
    final activeAsync = useState<bool>(isActive);
    useListenable(activeAsync);
    useEffect(() {
      return null;
    }, [activeAsync]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        elevation: 1,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.black,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          overlayColor: WidgetStatePropertyAll(Colors.black),
          onTap: () => onTap(isActive),
          child: AnimatedSize(
            duration: Duration(milliseconds: 400),
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: 34,
              padding: EdgeInsets.symmetric(horizontal: isTextBtn ? 16 : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isActive ? context.cardColor : context.cardColor,
              ),
              child: Row(
                children: [
                  if (!isTextBtn)
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: logo,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                  if (!isTextBtn) 5.hGap,
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return SizeTransition(
                          sizeFactor: animation, child: child);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: isTextBtn ? 0 : 3),
                      child: Text(
                        title,
                        style: body.copyWith(
                          color:
                              isActive ? context.iconColor : context.iconColor,
                          fontWeight:
                              isTextBtn ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
