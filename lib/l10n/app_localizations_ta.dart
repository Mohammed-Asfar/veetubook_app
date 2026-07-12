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
  String get listNameBase => 'பட்டியல்';

  @override
  String get searchLists => 'பட்டியல்களைத் தேடு';

  @override
  String get listsNoMatch => 'உங்கள் தேடலுக்குப் பொருந்தும் பட்டியல்கள் இல்லை.';

  @override
  String get renameList => 'பட்டியலை மறுபெயரிடு';

  @override
  String get changeDate => 'தேதியை மாற்று';

  @override
  String get deleteListConfirm =>
      'இந்தப் பட்டியலையும் அதன் பொருட்களையும் அழிக்கவா?';

  @override
  String get listItemsEmpty =>
      'இன்னும் பொருட்கள் இல்லை. உங்கள் பட்டியலிலிருந்து பொருட்களை அல்லது ஒரு தனிப் பொருளைச் சேர்க்கவும்.';

  @override
  String get addFromCatalog => 'பொருட்களைச் சேர்';

  @override
  String get addAdHocItem => 'தனிப் பொருள் சேர்';

  @override
  String get plannedTotal => 'திட்டமிட்டது';

  @override
  String get itemName => 'பொருள் பெயர்';

  @override
  String get addItem => 'பொருள் சேர்';

  @override
  String get editItem => 'பொருளைத் திருத்து';

  @override
  String pricePerUnit(String unit) {
    return 'ஒரு $unit விலை';
  }

  @override
  String get lineTotal => 'மொத்தம்';

  @override
  String get priceUpdatesCatalog =>
      'இந்த விலை அடுத்த முறைக்கும் சேமிக்கப்படும்.';

  @override
  String get searchProducts => 'தேடு அல்லது புதிய பொருள் சேர்';

  @override
  String get tabAll => 'அனைத்தும்';

  @override
  String get tabRecent => 'சமீபத்தியவை';

  @override
  String get recentEmpty =>
      'பட்டியல்களில் நீங்கள் சேர்க்கும் பொருட்கள் இங்கே தோன்றும்.';

  @override
  String createProductNamed(String name) {
    return '\"$name\" உருவாக்கு';
  }

  @override
  String get noProductsFound => 'பொருந்தும் பொருட்கள் இல்லை';

  @override
  String productAlreadyExists(String name) {
    return '\"$name\" ஏற்கனவே உங்கள் பொருட்களில் உள்ளது — சேர்க்க + ஐ தட்டவும்';
  }

  @override
  String get catalogTitle => 'பொருட்கள்';

  @override
  String get catalogEmpty =>
      'இன்னும் பொருட்கள் இல்லை. மீண்டும் பயன்படுத்த பொருட்களை அவற்றின் வழக்கமான விலையுடன் சேர்க்கவும்.';

  @override
  String get searchCatalog => 'பொருட்களைத் தேடு';

  @override
  String get catalogNoMatch => 'உங்கள் தேடலுக்குப் பொருந்தும் பொருட்கள் இல்லை.';

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
  String get autoCalcExample =>
      'எடுத்துக்காட்டு — பட்டியலில் சேர்க்கும்போது தானாகக் கணக்கிடப்படும்';

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
  String get expenseItemsTitle => 'வாங்கிய பொருட்கள்';

  @override
  String get expenseReadOnly => 'இது ஒரு பழைய பதிவு, இதைத் திருத்த முடியாது.';

  @override
  String get monthlySpend => 'மாதாந்திர செலவு';

  @override
  String get dailySpendThisMonth => 'இந்த மாத வாராந்திர செலவு';

  @override
  String trendingUp(String pct) {
    return 'இந்த மாதம் $pct% அதிகரித்துள்ளது';
  }

  @override
  String trendingDown(String pct) {
    return 'இந்த மாதம் $pct% குறைந்துள்ளது';
  }

  @override
  String showingLastMonths(int count) {
    return 'கடந்த $count மாதங்களின் மொத்த செலவு';
  }

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
  String get settingsAutoName => 'புதிய பட்டியல்களுக்கு தானாகப் பெயரிடு';

  @override
  String get settingsAutoNameHint =>
      'தானியங்கு பெயருடன் பட்டியல்களை உருவாக்கு. ஒவ்வொரு முறையும் பெயர் கேட்க இதை அணைக்கவும்.';

  @override
  String get sectionLists => 'பட்டியல்கள்';

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

  @override
  String get appTagline => 'உங்கள் வீட்டு மளிகை & செலவு புத்தகம்';

  @override
  String get onboardingSkip => 'தவிர்';

  @override
  String get onboardingNext => 'அடுத்து';

  @override
  String get onboardingBack => 'பின்';

  @override
  String get onboardingGetStarted => 'தொடங்கு';

  @override
  String onboardStep(int current, int total) {
    return 'படி $current / $total';
  }

  @override
  String get onboard1Title => 'பட்டியலை உருவாக்கு';

  @override
  String get onboard1Body =>
      'தயாராக உள்ள பொருட்களிலிருந்து சேர்க்கவும் அல்லது உங்கள் சொந்தப் பொருட்களை உருவாக்கவும். ஒவ்வொரு பொருளும் அதன் வழக்கமான விலையை நினைவில் வைக்கும்.';

  @override
  String get onboard2Title => 'வாங்கி குறியிடு';

  @override
  String get onboard2Body =>
      'ஷாப்பிங்கின் போது வாங்கிய பொருட்களைக் குறியிடவும். அளவைப் பொறுத்து விலை தானாகக் கணக்கிடப்படும் — எப்போது வேண்டுமானாலும் மாற்றலாம்.';

  @override
  String get onboard3Title => 'செலவைக் கண்காணி';

  @override
  String get onboard3Body =>
      'வாங்கிய பொருட்கள் தானாகவே மாதாந்திர செலவாகச் சேரும். இந்த மாதம் முந்தைய மாதத்துடன் எப்படி ஒப்பிடுகிறது என்பதைப் பார்க்கவும்.';

  @override
  String get onboard4Title => 'தமிழ் & ஆங்கிலம்';

  @override
  String get onboard4Body =>
      'அமைப்புகளில் எப்போது வேண்டுமானாலும் முழு ஆப்பையும் தமிழ் ⇄ ஆங்கிலம் மாற்றலாம். முழுவதும் ஆஃப்லைனில் இயங்கும்.';

  @override
  String get sectionHelp => 'உதவி';

  @override
  String get settingsHowItWorks => 'எப்படி வேலை செய்கிறது';

  @override
  String get settingsHowItWorksHint =>
      'விரைவு அறிமுகத்தை மீண்டும் பார்க்கவும்.';

  @override
  String get updateTitle => 'புதுப்பிப்பு கிடைக்கிறது';

  @override
  String updateMessage(String version, String current) {
    return 'பதிப்பு $version கிடைக்கிறது. உங்களிடம் $current உள்ளது.';
  }

  @override
  String get updateWhatsNew => 'புதியவை';

  @override
  String get updateNow => 'புதுப்பி';

  @override
  String get updateLater => 'பின்னர்';

  @override
  String get updateSkip => 'இந்தப் பதிப்பைத் தவிர்';

  @override
  String get settingsCheckUpdate => 'புதுப்பிப்புகளைச் சரிபார்';

  @override
  String settingsCheckUpdateHint(String version) {
    return 'பதிப்பு $version';
  }

  @override
  String get updateUpToDate => 'நீங்கள் சமீபத்திய பதிப்பில் உள்ளீர்கள்';
}
