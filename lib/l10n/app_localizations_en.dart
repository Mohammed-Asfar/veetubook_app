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
  String get renameList => 'Rename list';

  @override
  String get deleteListConfirm => 'Delete this list and its items?';

  @override
  String get listItemsEmpty =>
      'No items yet. Add products from your catalog or a one-off item.';

  @override
  String get addFromCatalog => 'Add from catalog';

  @override
  String get addAdHocItem => 'Add one-off item';

  @override
  String get plannedTotal => 'Planned';

  @override
  String get itemName => 'Item name';

  @override
  String get catalogTitle => 'Products';

  @override
  String get catalogEmpty =>
      'No products yet. Add products with their usual price to reuse them.';

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
  String get monthlySpend => 'Monthly spend';

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
}
