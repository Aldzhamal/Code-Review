import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_bloc.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_state.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: _blocListener,
      builder: (final BuildContext context, final SettingsState state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorsRes.primaryText,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: TextView(
              title: StringsRes.contactUs,
              size: TextSizes.sp23.sp,
              weight: FontWeight.w700,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: Dimensions.padding25.h,
                left: Dimensions.padding25.w,
                right: Dimensions.padding25.w,
                bottom: Dimensions.padding50.h,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _bodyController,
                      cursorColor: ColorsRes.primaryText,
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      enabled: true,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorsRes.primary,
                        hintText: StringsRes.message.tr(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsRes.primary,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius.r,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ColorsRes.primary),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius.r),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
              right: Dimensions.padding19.w,
              bottom: Dimensions.padding32.h,
            ),
            child: FloatingActionButton.extended(
              backgroundColor: _bodyController.value.text.isNotEmpty
                  ? ColorsRes.accent
                  : ColorsRes.subText,
              onPressed: () async {
                if (_bodyController.value.text.isNotEmpty) {
                  context.read<SettingsBloc>().add(SendMessage(
                        body: _bodyController.text,
                      ));
                  _bodyController.clear();
                }
              },
              label: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.margin14.w,
                ),
                child: TextView(
                  title: StringsRes.send,
                  weight: FontWeight.w400,
                  size: TextSizes.sp18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _blocListener(final BuildContext context, final SettingsState state) {
    if (state is MessageSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.responseMessage),
        ),
      );
    }
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }
}
