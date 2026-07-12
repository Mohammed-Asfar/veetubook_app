// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'veetubook';

  @override
  String get navLists => 'Lists';

  @override
  String get navCatalog => 'Products';

  @override
  String get navExpenses => 'Expenses';

  @override
  String get navSettings => 'Settings';

  @override
  String get listsTitle => 'Grocery Lists';

  @override
  String get listsEmpty =>
      'No lists yet. Tap + to create your first grocery list.';

  @override
  String get newList => 'New list';

  @override
  String get listName => 'List name';

  @override
  String get listNameBase => 'List';

  @override
  String get searchLists => 'Search lists';

  @override
  String get listsNoMatch => 'No lists match your search.';

  @override
  String get renameList => 'Rename list';

  @override
  String get changeDate => 'Change date';

  @override
  String get deleteListConfirm => 'Delete this list and its items?';

  @override
  String get listItemsEmpty =>
      'No items yet. Add products from your catalog or a one-off item.';

  @override
  String get addFromCatalog => 'Add items';

  @override
  String get addAdHocItem => 'Add one-off item';

  @override
  String get plannedTotal => 'Planned';

  @override
  String get itemName => 'Item name';

  @override
  String get addItem => 'Add item';

  @override
  String get editItem => 'Edit item';

  @override
  String pricePerUnit(String unit) {
    return 'Price per $unit';
  }

  @override
  String get lineTotal => 'Total';

  @override
  String get priceUpdatesCatalog => 'This price is saved for next time too.';

  @override
  String get searchProducts => 'Search or add new item';

  @override
  String get tabAll => 'All';

  @override
  String get tabRecent => 'Recent';

  @override
  String get recentEmpty => 'Items you add to lists will show up here.';

  @override
  String createProductNamed(String name) {
    return 'Create \"$name\"';
  }

  @override
  String get noProductsFound => 'No matching products';

  @override
  String productAlreadyExists(String name) {
    return '\"$name\" is already in your products — tap + to add it';
  }

  @override
  String get catalogTitle => 'Products';

  @override
  String get catalogEmpty =>
      'No products yet. Add products with their usual price to reuse them.';

  @override
  String get searchCatalog => 'Search products';

  @override
  String get catalogNoMatch => 'No products match your search.';

  @override
  String get addProduct => 'Add product';

  @override
  String get editProduct => 'Edit product';

  @override
  String get basePrice => 'Price';

  @override
  String get unit => 'Unit';

  @override
  String get quantity => 'Quantity';

  @override
  String get category => 'Category';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get nameEnglish => 'Name (English)';

  @override
  String get nameTamil => 'Name (Tamil)';

  @override
  String get nameRequired => 'Enter at least one name (Tamil or English)';

  @override
  String priceForQty(String qty, String unit) {
    return 'Price for $qty $unit';
  }

  @override
  String get autoCalcExample =>
      'Example — auto-calculated when added to a list';

  @override
  String get deleteProductConfirm =>
      'Delete this product? Past purchases keep their recorded price.';

  @override
  String get shoppingTitle => 'Shopping';

  @override
  String get runningTotal => 'Total';

  @override
  String get markBought => 'Bought';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get expensesEmpty =>
      'No expenses yet. Finish a shopping trip to see it here.';

  @override
  String get expenseItemsTitle => 'Items bought';

  @override
  String get expenseReadOnly => 'This is a past record and can\'t be edited.';

  @override
  String get monthlySpend => 'Monthly spend';

  @override
  String get dailySpendThisMonth => 'Weekly spend this month';

  @override
  String trendingUp(String pct) {
    return 'Trending up by $pct% this month';
  }

  @override
  String trendingDown(String pct) {
    return 'Trending down by $pct% this month';
  }

  @override
  String showingLastMonths(int count) {
    return 'Showing total spend for the last $count months';
  }

  @override
  String get vsPreviousMonth => 'vs previous month';

  @override
  String get noPriorData => 'No prior month to compare';

  @override
  String get soFarThisMonth => 'so far this month';

  @override
  String get finishTrip => 'Finish trip';

  @override
  String get finishTripConfirm =>
      'Finish this trip? The total of bought items will be saved as an expense.';

  @override
  String get tripFinished => 'Trip saved to expenses';

  @override
  String trips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips',
      one: '1 trip',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsExport => 'Export data (CSV)';

  @override
  String get settingsExportHint =>
      'Save a backup of your expenses. Uninstalling the app deletes all data.';

  @override
  String get settingsAutoName => 'Auto-name new lists';

  @override
  String get settingsAutoNameHint =>
      'Create lists with an automatic name. Turn off to be asked for a name each time.';

  @override
  String get sectionLists => 'Lists';

  @override
  String get settingsClearData => 'Clear all data';

  @override
  String get settingsClearDataHint =>
      'Delete all lists, products and expenses. This cannot be undone.';

  @override
  String get clearDataConfirm =>
      'Delete ALL data? Export a backup first if you want to keep it. This cannot be undone.';

  @override
  String get exportDone => 'Exported';

  @override
  String get clearDone => 'All data cleared';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTamil => 'Tamil';

  @override
  String get sectionData => 'Data';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get appTagline => 'Your household grocery & spending book';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String onboardStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboard1Title => 'Build your list';

  @override
  String get onboard1Body =>
      'Add items from the ready-made catalog or create your own. Every product remembers its usual price.';

  @override
  String get onboard2Title => 'Shop & check off';

  @override
  String get onboard2Body =>
      'Mark items as bought while you shop. The line price is calculated automatically from the quantity — change it anytime.';

  @override
  String get onboard3Title => 'Track your spending';

  @override
  String get onboard3Body =>
      'Bought items add up into a monthly expense automatically. See how this month compares to the last.';

  @override
  String get onboard4Title => 'Tamil & English';

  @override
  String get onboard4Body =>
      'Switch the whole app between Tamil and English anytime in Settings. Works fully offline.';

  @override
  String get sectionHelp => 'Help';

  @override
  String get settingsHowItWorks => 'How it works';

  @override
  String get settingsHowItWorksHint => 'See the quick intro again.';

  @override
  String get updateTitle => 'Update available';

  @override
  String updateMessage(String version, String current) {
    return 'Version $version is available. You have $current.';
  }

  @override
  String get updateWhatsNew => 'What\'s new';

  @override
  String get updateNow => 'Update';

  @override
  String get updateLater => 'Later';

  @override
  String get updateSkip => 'Skip this version';

  @override
  String get settingsCheckUpdate => 'Check for updates';

  @override
  String settingsCheckUpdateHint(String version) {
    return 'Version $version';
  }

  @override
  String get updateUpToDate => 'You\'re on the latest version';
}
