import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'veetubook'**
  String get appTitle;

  /// No description provided for @navLists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get navLists;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navCatalog;

  /// No description provided for @navExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navExpenses;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @listsTitle.
  ///
  /// In en, this message translates to:
  /// **'Grocery Lists'**
  String get listsTitle;

  /// No description provided for @listsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No lists yet. Tap + to create your first grocery list.'**
  String get listsEmpty;

  /// No description provided for @newList.
  ///
  /// In en, this message translates to:
  /// **'New list'**
  String get newList;

  /// No description provided for @listName.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get listName;

  /// No description provided for @listNameBase.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listNameBase;

  /// No description provided for @searchLists.
  ///
  /// In en, this message translates to:
  /// **'Search lists'**
  String get searchLists;

  /// No description provided for @listsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No lists match your search.'**
  String get listsNoMatch;

  /// No description provided for @renameList.
  ///
  /// In en, this message translates to:
  /// **'Rename list'**
  String get renameList;

  /// No description provided for @changeDate.
  ///
  /// In en, this message translates to:
  /// **'Change date'**
  String get changeDate;

  /// No description provided for @deleteListConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this list and its items?'**
  String get deleteListConfirm;

  /// No description provided for @listItemsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Add products from your catalog or a one-off item.'**
  String get listItemsEmpty;

  /// No description provided for @addFromCatalog.
  ///
  /// In en, this message translates to:
  /// **'Add items'**
  String get addFromCatalog;

  /// No description provided for @addAdHocItem.
  ///
  /// In en, this message translates to:
  /// **'Add one-off item'**
  String get addAdHocItem;

  /// No description provided for @plannedTotal.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get plannedTotal;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItem;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price per {unit}'**
  String pricePerUnit(String unit);

  /// No description provided for @lineTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get lineTotal;

  /// No description provided for @priceUpdatesCatalog.
  ///
  /// In en, this message translates to:
  /// **'This price is saved for next time too.'**
  String get priceUpdatesCatalog;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search or add new item'**
  String get searchProducts;

  /// No description provided for @tabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// No description provided for @tabRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get tabRecent;

  /// No description provided for @recentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Items you add to lists will show up here.'**
  String get recentEmpty;

  /// No description provided for @createProductNamed.
  ///
  /// In en, this message translates to:
  /// **'Create \"{name}\"'**
  String createProductNamed(String name);

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No matching products'**
  String get noProductsFound;

  /// No description provided for @productAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" is already in your products — tap + to add it'**
  String productAlreadyExists(String name);

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get catalogTitle;

  /// No description provided for @catalogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet. Add products with their usual price to reuse them.'**
  String get catalogEmpty;

  /// No description provided for @searchCatalog.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchCatalog;

  /// No description provided for @catalogNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No products match your search.'**
  String get catalogNoMatch;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProduct;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get basePrice;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @nameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get nameEnglish;

  /// No description provided for @nameTamil.
  ///
  /// In en, this message translates to:
  /// **'Name (Tamil)'**
  String get nameTamil;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one name (Tamil or English)'**
  String get nameRequired;

  /// No description provided for @priceForQty.
  ///
  /// In en, this message translates to:
  /// **'Price for {qty} {unit}'**
  String priceForQty(String qty, String unit);

  /// Header clarifying the auto-calc preview is just an example, not a saved field
  ///
  /// In en, this message translates to:
  /// **'Example — auto-calculated when added to a list'**
  String get autoCalcExample;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this product? Past purchases keep their recorded price.'**
  String get deleteProductConfirm;

  /// No description provided for @shoppingTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shoppingTitle;

  /// No description provided for @runningTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get runningTotal;

  /// No description provided for @markBought.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get markBought;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet. Finish a shopping trip to see it here.'**
  String get expensesEmpty;

  /// No description provided for @expenseItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items bought'**
  String get expenseItemsTitle;

  /// No description provided for @expenseReadOnly.
  ///
  /// In en, this message translates to:
  /// **'This is a past record and can\'t be edited.'**
  String get expenseReadOnly;

  /// No description provided for @monthlySpend.
  ///
  /// In en, this message translates to:
  /// **'Monthly spend'**
  String get monthlySpend;

  /// No description provided for @dailySpendThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Weekly spend this month'**
  String get dailySpendThisMonth;

  /// No description provided for @trendingUp.
  ///
  /// In en, this message translates to:
  /// **'Trending up by {pct}% this month'**
  String trendingUp(String pct);

  /// No description provided for @trendingDown.
  ///
  /// In en, this message translates to:
  /// **'Trending down by {pct}% this month'**
  String trendingDown(String pct);

  /// No description provided for @showingLastMonths.
  ///
  /// In en, this message translates to:
  /// **'Showing total spend for the last {count} months'**
  String showingLastMonths(int count);

  /// No description provided for @vsPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'vs previous month'**
  String get vsPreviousMonth;

  /// No description provided for @noPriorData.
  ///
  /// In en, this message translates to:
  /// **'No prior month to compare'**
  String get noPriorData;

  /// No description provided for @soFarThisMonth.
  ///
  /// In en, this message translates to:
  /// **'so far this month'**
  String get soFarThisMonth;

  /// No description provided for @finishTrip.
  ///
  /// In en, this message translates to:
  /// **'Finish trip'**
  String get finishTrip;

  /// No description provided for @finishTripConfirm.
  ///
  /// In en, this message translates to:
  /// **'Finish this trip? The total of bought items will be saved as an expense.'**
  String get finishTripConfirm;

  /// No description provided for @tripFinished.
  ///
  /// In en, this message translates to:
  /// **'Trip saved to expenses'**
  String get tripFinished;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 trip} other{{count} trips}}'**
  String trips(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export data (CSV)'**
  String get settingsExport;

  /// No description provided for @settingsExportHint.
  ///
  /// In en, this message translates to:
  /// **'Save a backup of your expenses. Uninstalling the app deletes all data.'**
  String get settingsExportHint;

  /// No description provided for @settingsAutoName.
  ///
  /// In en, this message translates to:
  /// **'Auto-name new lists'**
  String get settingsAutoName;

  /// No description provided for @settingsAutoNameHint.
  ///
  /// In en, this message translates to:
  /// **'Create lists with an automatic name. Turn off to be asked for a name each time.'**
  String get settingsAutoNameHint;

  /// No description provided for @sectionLists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get sectionLists;

  /// No description provided for @settingsClearData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearData;

  /// No description provided for @settingsClearDataHint.
  ///
  /// In en, this message translates to:
  /// **'Delete all lists, products and expenses. This cannot be undone.'**
  String get settingsClearDataHint;

  /// No description provided for @clearDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete ALL data? Export a backup first if you want to keep it. This cannot be undone.'**
  String get clearDataConfirm;

  /// No description provided for @exportDone.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get exportDone;

  /// No description provided for @clearDone.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get clearDone;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get languageTamil;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your household grocery & spending book'**
  String get appTagline;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardStep(int current, int total);

  /// No description provided for @onboard1Title.
  ///
  /// In en, this message translates to:
  /// **'Build your list'**
  String get onboard1Title;

  /// No description provided for @onboard1Body.
  ///
  /// In en, this message translates to:
  /// **'Add items from the ready-made catalog or create your own. Every product remembers its usual price.'**
  String get onboard1Body;

  /// No description provided for @onboard2Title.
  ///
  /// In en, this message translates to:
  /// **'Shop & check off'**
  String get onboard2Title;

  /// No description provided for @onboard2Body.
  ///
  /// In en, this message translates to:
  /// **'Mark items as bought while you shop. The line price is calculated automatically from the quantity — change it anytime.'**
  String get onboard2Body;

  /// No description provided for @onboard3Title.
  ///
  /// In en, this message translates to:
  /// **'Track your spending'**
  String get onboard3Title;

  /// No description provided for @onboard3Body.
  ///
  /// In en, this message translates to:
  /// **'Bought items add up into a monthly expense automatically. See how this month compares to the last.'**
  String get onboard3Body;

  /// No description provided for @onboard4Title.
  ///
  /// In en, this message translates to:
  /// **'Tamil & English'**
  String get onboard4Title;

  /// No description provided for @onboard4Body.
  ///
  /// In en, this message translates to:
  /// **'Switch the whole app between Tamil and English anytime in Settings. Works fully offline.'**
  String get onboard4Body;

  /// No description provided for @sectionHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get sectionHelp;

  /// No description provided for @settingsHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get settingsHowItWorks;

  /// No description provided for @settingsHowItWorksHint.
  ///
  /// In en, this message translates to:
  /// **'See the quick intro again.'**
  String get settingsHowItWorksHint;

  /// No description provided for @updateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateTitle;

  /// No description provided for @updateMessage.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available. You have {current}.'**
  String updateMessage(String version, String current);

  /// No description provided for @updateWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get updateWhatsNew;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip this version'**
  String get updateSkip;

  /// No description provided for @settingsCheckUpdate.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get settingsCheckUpdate;

  /// No description provided for @settingsCheckUpdateHint.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsCheckUpdateHint(String version);

  /// No description provided for @updateUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the latest version'**
  String get updateUpToDate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
