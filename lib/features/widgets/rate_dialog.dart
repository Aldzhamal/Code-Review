import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/utils/storage_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rating_dialog/rating_dialog.dart';
import 'package:store_redirect/store_redirect.dart';

class RateDialog extends StatelessWidget {
  const RateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingDialog(
      initialRating: 5.0,
      showCloseButton: true,
      onCancelled: () async {
        await getIt<Storage>().setIsUserRatted(true);
      },
      title: Text(
        StringsRes.appName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: TextSizes.sp23.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        StringsRes.tapStar.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: TextSizes.sp15.sp),
      ),
      image: Image.asset(
        IconsRes.logo,
        width: Dimensions.size100.w,
        height: Dimensions.size100.w,
      ),
      submitButtonText: StringsRes.submit.tr(),
      commentHint: StringsRes.addComment.tr(),
      onSubmitted: (RatingDialogResponse response) async {
        await getIt<Storage>().setIsUserRatted(true);
        if (response.rating > 3.0) {
          //Todo(Issa): need to change
          StoreRedirect.redirect(
              androidAppId: 'com.syject.neocleaner',
              iOSAppId: 'com.syject.neocleaner');
        }
      },
    );
    ;
  }
}
