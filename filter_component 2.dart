import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_car/services/services.dart';
import 'package:love_car/src/global/global.dart';
import 'package:love_car/src/pages/discount_shop/presentation/components/filter_bottom_sheet.dart';

class FilterComponent extends HookConsumerWidget {
  const FilterComponent(this.filterData,
      {required this.onConfirmed, super.key});
  final Map<String, dynamic>? filterData;
  final void Function(Map<String, dynamic>?) onConfirmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputText = useState<String?>(null);
    final _filterData = useState<Map<String, dynamic>?>(filterData);
    final containFilter = useState<bool>(false);
    useListenable(_filterData);
    useListenable(containFilter);

    void updateFilter() {
      _filterData.value = {
        ...?_filterData.value,
        'name': inputText.value,
      }..removeWhere((key, value) => value == null);

      containFilter.value =
          (_filterData.value?.containsKey('state_id') ?? false) ||
              (_filterData.value?.containsKey('city_id') ?? false);
    }

    useEffect(() {
      final filters = _filterData.value;
      if (filters == null) return null;
      if (filters.containsKey('name')) {
        inputText.value = filters['name'].toString();
      }
      return null;
    }, [_filterData.value]);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(
          bottom: BorderSide(color: context.hintColor, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            '✨ Enjoy our best offer —\nexclusively for all LoveCar App users! 🎉💖',
            textAlign: TextAlign.center,
            style: body.textColor(themeColor),
          ),
          7.vGap,
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.iconColor, width: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'Search discount shops',
                        hintStyle: loginTextStyle.textColor(
                            context.iconColor.withAlpha((0.4 * 255).toInt())),
                      ),
                      cursorColor: context.iconColor,
                      style: loginTextStyle.textColor(context.iconColor),
                      onChanged: (val) {
                        inputText.value = val;
                        updateFilter();
                        onConfirmed(_filterData.value);
                      },
                    ),
                  ),
                ),
                10.hGap,
                Stack(
                  children: [
                    CupertinoBtn(
                      color: const Color(0xff7360F2),
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
                        color: Colors.white,
                      ),
                    ),
                    if (containFilter.value)
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
              ],
            ),
          ),
          4.vGap,
        ],
      ),
    );
  }
}
