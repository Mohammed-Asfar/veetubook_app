// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'வீட்டு புக்';

  @override
  String get navLists => 'பட்டியல்கள்';

  @override
  String get navCatalog => 'பொருட்கள்';

  @override
  String get navExpenses => 'செலவுகள்';

  @override
  String get navSettings => 'அமைப்புகள்';

  @override
  String get listsTitle => 'மளிகை பட்டியல்கள்';

  @override
  String get listsEmpty =>
      'இன்னும் பட்டியல்கள் இல்லை. உங்கள் முதல் மளிகை பட்டியலை உருவாக்க + ஐ தட்டவும்.';

  @override
  String get newList => 'புதிய பட்டியல்';

  @override
  String get listName => 'பட்டியல் பெயர்';

  @override
  String get renameList => 'பட்டியலை மறுபெயரிடு';

  @override
  String get deleteListConfirm =>
      'இந்தப் பட்டியலையும் அதன் பொருட்களையும் அழிக்கவா?';

  @override
  String get listItemsEmpty =>
      'இன்னும் பொருட்கள் இல்லை. உங்கள் பட்டியலிலிருந்து பொருட்களை அல்லது ஒரு தனிப் பொருளைச் சேர்க்கவும்.';

  @override
  String get addFromCatalog => 'பட்டியலிலிருந்து சேர்';

  @override
  String get addAdHocItem => 'தனிப் பொருள் சேர்';

  @override
  String get plannedTotal => 'திட்டமிட்டது';

  @override
  String get itemName => 'பொருள் பெயர்';

  @override
  String get catalogTitle => 'பொருட்கள்';

  @override
  String get catalogEmpty =>
      'இன்னும் பொருட்கள் இல்லை. மீண்டும் பயன்படுத்த பொருட்களை அவற்றின் வழக்கமான விலையுடன் சேர்க்கவும்.';

  @override
  String get addProduct => 'பொருள் சேர்';

  @override
  String get editProduct => 'பொருளைத் திருத்து';

  @override
  String get basePrice => 'விலை';

  @override
  String get unit => 'அலகு';

  @override
  String get quantity => 'அளவு';

  @override
  String get category => 'வகை';

  @override
  String get uncategorized => 'வகைப்படுத்தப்படாதவை';

  @override
  String get nameEnglish => 'பெயர் (ஆங்கிலம்)';

  @override
  String get nameTamil => 'பெயர் (தமிழ்)';

  @override
  String get nameRequired =>
      'குறைந்தது ஒரு பெயரையாவது உள்ளிடவும் (தமிழ் அல்லது ஆங்கிலம்)';

  @override
  String priceForQty(String qty, String unit) {
    return '$qty $unit விலை';
  }

  @override
  String get deleteProductConfirm =>
      'இந்தப் பொருளை அழிக்கவா? கடந்த வாங்குதல்கள் பதிவு செய்யப்பட்ட விலையை தக்கவைத்துக்கொள்ளும்.';

  @override
  String get shoppingTitle => 'ஷாப்பிங்';

  @override
  String get runningTotal => 'மொத்தம்';

  @override
  String get markBought => 'வாங்கியது';

  @override
  String get expensesTitle => 'செலவுகள்';

  @override
  String get expensesEmpty =>
      'இன்னும் செலவுகள் இல்லை. ஒரு ஷாப்பிங்கை முடித்தால் இங்கே தெரியும்.';

  @override
  String get monthlySpend => 'மாதாந்திர செலவு';

  @override
  String get vsPreviousMonth => 'முந்தைய மாதத்துடன் ஒப்பிடும்போது';

  @override
  String get noPriorData => 'ஒப்பிட முந்தைய மாதம் இல்லை';

  @override
  String get soFarThisMonth => 'இந்த மாதம் இதுவரை';

  @override
  String get finishTrip => 'ஷாப்பிங்கை முடி';

  @override
  String get finishTripConfirm =>
      'இந்த ஷாப்பிங்கை முடிக்கவா? வாங்கிய பொருட்களின் மொத்தம் செலவாகச் சேமிக்கப்படும்.';

  @override
  String get tripFinished => 'செலவுகளில் சேமிக்கப்பட்டது';

  @override
  String trips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ஷாப்பிங்குகள்',
      one: '1 ஷாப்பிங்',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get settingsLanguage => 'மொழி';

  @override
  String get settingsCurrency => 'நாணயம்';

  @override
  String get settingsExport => 'தரவை ஏற்றுமதி (CSV)';

  @override
  String get settingsExportHint =>
      'உங்கள் செலவுகளின் காப்புப்பிரதியைச் சேமிக்கவும். ஆப்பை நீக்கினால் அனைத்து தரவும் நீங்கும்.';

  @override
  String get settingsClearData => 'அனைத்து தரவையும் அழி';

  @override
  String get settingsClearDataHint =>
      'அனைத்து பட்டியல்கள், பொருட்கள், செலவுகளை நீக்கும். இதை மீட்க முடியாது.';

  @override
  String get clearDataConfirm =>
      'அனைத்து தரவையும் நீக்கவா? வைத்திருக்க விரும்பினால் முதலில் காப்புப்பிரதி எடுக்கவும். இதை மீட்க முடியாது.';

  @override
  String get exportDone => 'ஏற்றுமதி செய்யப்பட்டது';

  @override
  String get clearDone => 'அனைத்து தரவும் அழிக்கப்பட்டது';

  @override
  String get languageEnglish => 'ஆங்கிலம்';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get sectionData => 'தரவு';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்கள்',
      one: '1 பொருள்',
      zero: 'பொருட்கள் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get commonSave => 'சேமி';

  @override
  String get commonCancel => 'ரத்து';

  @override
  String get commonDelete => 'அழி';

  @override
  String get commonConfirm => 'உறுதிப்படுத்து';
}
