import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/utils/data_utils.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static String get routeName => 'register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nickNameFormKey = GlobalKey<FormState>();
  String _nickName = '';
  DateTime _tempSavedDate = DateTime.now();
  DateTime _selectedBirthdayDate = DateTime.now();
  String _birthday = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _gender = 'MAN';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        final resp = await showConfirmationDialog(
          context: context,
          content: '회원 등록을 취소하시겠습니까?',
          confirmText: '등록 취소',
          cancelText: '계속하기',
        );

        if (resp == true) {
          ref.read(userInfoProvider.notifier).cancelRegister();
        }
      },
      child: DefaultLayout(
        titleWidget: const Text('기본 회원 정보 등록'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _nickNameFormKey,
                child: CustomTextFormField(
                  labelText: '닉네임',
                  validator: DataUtils.validateNickname,
                  autovalidateMode: AutovalidateMode.always,
                  onSaved: (value) {
                    _nickName = value ?? '';
                  },
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                _birthday,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: Colors.white,
                      height: 300,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: _selectedBirthdayDate,
                              minimumYear: 1900,
                              maximumYear: DateTime.now().year,
                              onDateTimeChanged: (DateTime newDateTime) {
                                _tempSavedDate = newDateTime;
                              },
                            ),
                          ),
                          CupertinoButton(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _selectedBirthdayDate = _tempSavedDate;
                                _birthday = DateFormat('yyyy-MM-dd')
                                    .format(_selectedBirthdayDate);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                child: const Text('생일선택'),
              ),
              const SizedBox(height: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '성별',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'MAN',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value ?? 'MAN';
                          });
                        },
                      ),
                      const Text('남성'),
                      Radio<String>(
                        value: 'WOMAN',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value ?? 'WOMAN';
                          });
                        },
                      ),
                      const Text('여성'),
                      Radio<String>(
                        value: 'NONE',
                        groupValue: _gender,
                        onChanged: null,
                      ),
                      const Text('선택안함'),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_nickNameFormKey.currentState!.validate()) {
                          return;
                        }
                        _nickNameFormKey.currentState!.save();

                        ref.read(userInfoProvider.notifier).register(
                              nickname: _nickName,
                              sex: _gender,
                              birthday: _birthday,
                            );
                      },
                      child: const Text('다음'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
