import 'languages.dart';

class LanguageCn extends BaseLanguage {
  @override
  String get login => '登陆';

  @override
  String get email => '邮箱';

  @override
  String get phoneNumber => '手机号';

  @override
  String get signIn => '注册';

  @override
  String get internetNotAvailable => '无法连接到互联网';

  @override
  String get pleaseTryAgain => '请重试';

  @override
  String get requiredText => '此字段为必填项';

  @override
  String get somethingWentWrong => '发生了一些问题';

  @override
  String get enterYourPhoneEmail => '填入手机号/邮箱';

  @override
  String get continueWord => '继续';

  @override
  String get continueWithApple => '使用苹果账号继续';

  @override
  String get continueWithFb => '使用Facebook继续';

  @override
  String get continueWithGoogle => '使用Google账号继续';

  @override
  String get createAccount => '创建账号';

  @override
  String get dontHaveAccount => '还没有账号';

  @override
  String get or => '或';

  @override
  String get infoCollectionStatement => '声明条款';

  @override
  String get agreementText => '声明条款内容——待补充';

  @override
  String get close => '关闭';

  @override
  String get theEnteredCodeIsInvalidPleaseTryAgain => '输入信息有误，请重新输入';

  @override
  String get verified => "验证成功";

  @override
  String get appleSignInNotAvailable => "不支持Apple登陆";

  @override
  // TODO: implement lblSignInFailed
  String get lblSignInFailed => throw UnimplementedError();

  @override
  // TODO: implement lblUserCancelled
  String get lblUserCancelled => throw UnimplementedError();

}
