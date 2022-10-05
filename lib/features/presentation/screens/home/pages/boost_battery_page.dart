import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cleaner_code_review/core/data_holder/home_data.dart';
import 'package:cleaner_code_review/core/enums/enums.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_bloc.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_state.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/components/nav_button.dart';
import 'package:cleaner_code_review/features/widgets/start_button.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoostBatteryPage extends StatefulWidget {
  const BoostBatteryPage({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  final AdaptiveThemeMode themeMode;

  @override
  BoostBatteryPageState createState() => BoostBatteryPageState();
}

class BoostBatteryPageState extends State<BoostBatteryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: _blocListener,
      builder: (BuildContext context, HomeState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Spacer(),
            StartButton(
              onTap: () =>
                  context.read<HomeBloc>().add(const StartCleanTrash()),
              icon: IconsRes.startBattery,
            ),
            SizedBox(
              height: Dimensions.margin20.h,
            ),
            const Spacer(),
            NavButton(
              title: StringsRes.cleanCacheNav,
              icon: IconsRes.cache,
              onTap: () => context.read<HomeBloc>().add(
                    const ChangePage(
                      pageNum: 1,
                      pageType: HomePageType.cleanCache,
                    ),
                  ),
            ),
            SizedBox(
              height: Dimensions.margin20.h,
            ),
            NavButton(
              title: StringsRes.cleanTrashNav,
              icon: IconsRes.trash,
              onTap: () => context.read<HomeBloc>().add(
                    const ChangePage(
                      pageNum: 2,
                      pageType: HomePageType.cleanTrash,
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }

  void _blocListener(final BuildContext context, final HomeState state) {}

  @override
  void dispose() {
    super.dispose();
  }
}
