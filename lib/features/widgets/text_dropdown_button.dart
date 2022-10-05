import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextDropdownButton extends StatelessWidget {
  const TextDropdownButton({
    super.key,
    required this.text,
    required this.list,
    required this.dropdownValue,
    required this.onValueChanged,
  });

  final List<String> list;
  final String text;
  final String dropdownValue;
  final ValueChanged<String?> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.padding22.h,
        vertical: Dimensions.padding12.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextView(
            size: TextSizes.sp18.sp,
            title: text,
            weight: FontWeight.w400,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.padding25.h,
              vertical: Dimensions.padding6.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ColorsRes.navBackGround,
              border: Border.all(
                width: 1.0,
                color: ColorsRes.frame,
              ),
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(20),
              dropdownColor: ColorsRes.navBackGround,
              value: dropdownValue,
              isDense: true,
              icon: const Icon(Icons.arrow_drop_down,
                  color: ColorsRes.activeColorSwitch),
              iconSize: Dimensions.padding22.h,
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              onChanged: onValueChanged,
              items: list
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
