import 'package:decimal/decimal.dart';

import '../domain/catalog_repository.dart';
import '../domain/entities/category.dart';
import '../domain/entities/product.dart';

/// Seeds a starter catalog of common Tamil household grocery items on first
/// launch so the app is useful immediately (PRD suggestion). Runs only when the
/// catalog is empty.
class CatalogSeeder {
  const CatalogSeeder(this._repo);

  final CatalogRepository _repo;

  Future<void> seedIfEmpty() async {
    if (await _repo.productCount() > 0) return;

    // Categories first, keep their ids to attach products.
    final categoryIds = <String, int>{};
    for (final c in _seedCategories) {
      final id = await _repo.saveCategory(Category(nameTa: c.$2, nameEn: c.$1));
      categoryIds[c.$1] = id;
    }

    for (final p in _seedProducts) {
      await _repo.saveProduct(
        Product(
          nameEn: p.nameEn,
          nameTa: p.nameTa,
          unit: p.unit,
          baseQty: Decimal.one,
          basePricePaise: p.rupees * 100,
          categoryId: categoryIds[p.category],
        ),
      );
    }
  }

  // (englishCategory, tamilCategory)
  static const List<(String, String)> _seedCategories = [
    ('Grains & Rice', 'தானியங்கள் & அரிசி'),
    ('Pulses & Dals', 'பருப்பு வகைகள்'),
    ('Oils & Ghee', 'எண்ணெய் & நெய்'),
    ('Spices', 'மசாலா பொருட்கள்'),
    ('Vegetables', 'காய்கறிகள்'),
    ('Dairy', 'பால் பொருட்கள்'),
    ('Others', 'மற்றவை'),
  ];

  static const List<_SeedProduct> _seedProducts = [
    // Grains & Rice
    _SeedProduct('Ponni Rice', 'பொன்னி அரிசி', 'kg', 60, 'Grains & Rice'),
    _SeedProduct('Idli Rice', 'இட்லி அரிசி', 'kg', 55, 'Grains & Rice'),
    _SeedProduct('Wheat Flour', 'கோதுமை மாவு', 'kg', 45, 'Grains & Rice'),
    _SeedProduct('Rava / Sooji', 'ரவை', 'kg', 50, 'Grains & Rice'),
    _SeedProduct('Poha / Aval', 'அவல்', 'kg', 60, 'Grains & Rice'),
    // Pulses & Dals
    _SeedProduct('Toor Dal', 'துவரம் பருப்பு', 'kg', 140, 'Pulses & Dals'),
    _SeedProduct('Moong Dal', 'பாசிப் பருப்பு', 'kg', 120, 'Pulses & Dals'),
    _SeedProduct('Urad Dal', 'உளுந்து', 'kg', 130, 'Pulses & Dals'),
    _SeedProduct('Channa Dal', 'கடலை பருப்பு', 'kg', 90, 'Pulses & Dals'),
    _SeedProduct('Green Gram', 'பச்சை பயறு', 'kg', 110, 'Pulses & Dals'),
    // Oils & Ghee
    _SeedProduct('Sunflower Oil', 'சூரியகாந்தி எண்ணெய்', 'litre', 130, 'Oils & Ghee'),
    _SeedProduct('Gingelly Oil', 'நல்லெண்ணெய்', 'litre', 250, 'Oils & Ghee'),
    _SeedProduct('Ghee', 'நெய்', 'litre', 600, 'Oils & Ghee'),
    _SeedProduct('Coconut Oil', 'தேங்காய் எண்ணெய்', 'litre', 220, 'Oils & Ghee'),
    // Spices
    _SeedProduct('Salt', 'உப்பு', 'kg', 20, 'Spices'),
    _SeedProduct('Red Chilli Powder', 'மிளகாய் தூள்', 'kg', 300, 'Spices'),
    _SeedProduct('Turmeric Powder', 'மஞ்சள் தூள்', 'kg', 200, 'Spices'),
    _SeedProduct('Coriander Powder', 'மல்லி தூள்', 'kg', 180, 'Spices'),
    _SeedProduct('Mustard', 'கடுகு', 'kg', 120, 'Spices'),
    _SeedProduct('Cumin', 'சீரகம்', 'kg', 300, 'Spices'),
    _SeedProduct('Tamarind', 'புளி', 'kg', 120, 'Spices'),
    // Vegetables
    _SeedProduct('Onion', 'வெங்காயம்', 'kg', 30, 'Vegetables'),
    _SeedProduct('Tomato', 'தக்காளி', 'kg', 25, 'Vegetables'),
    _SeedProduct('Potato', 'உருளைக்கிழங்கு', 'kg', 30, 'Vegetables'),
    _SeedProduct('Green Chilli', 'பச்சை மிளகாய்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Garlic', 'பூண்டு', 'kg', 120, 'Vegetables'),
    _SeedProduct('Ginger', 'இஞ்சி', 'kg', 80, 'Vegetables'),
    _SeedProduct('Curry Leaves', 'கறிவேப்பிலை', 'bunch', 10, 'Vegetables'),
    _SeedProduct('Coriander Leaves', 'கொத்தமல்லி', 'bunch', 10, 'Vegetables'),
    _SeedProduct('Carrot', 'கேரட்', 'kg', 50, 'Vegetables'),
    _SeedProduct('Beans', 'பீன்ஸ்', 'kg', 60, 'Vegetables'),
    _SeedProduct('Brinjal', 'கத்தரிக்காய்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Lady Finger', 'வெண்டைக்காய்', 'kg', 50, 'Vegetables'),
    // Dairy
    _SeedProduct('Milk', 'பால்', 'litre', 48, 'Dairy'),
    _SeedProduct('Curd', 'தயிர்', 'kg', 60, 'Dairy'),
    _SeedProduct('Butter', 'வெண்ணெய்', 'unit', 55, 'Dairy'),
    _SeedProduct('Paneer', 'பன்னீர்', 'kg', 350, 'Dairy'),
    // Others
    _SeedProduct('Sugar', 'சர்க்கரை', 'kg', 45, 'Others'),
    _SeedProduct('Tea Powder', 'தேயிலை தூள்', 'kg', 400, 'Others'),
    _SeedProduct('Coffee Powder', 'காபி தூள்', 'kg', 500, 'Others'),
    _SeedProduct('Eggs', 'முட்டை', 'piece', 6, 'Others'),
  ];
}

class _SeedProduct {
  const _SeedProduct(
    this.nameEn,
    this.nameTa,
    this.unit,
    this.rupees,
    this.category,
  );
  final String nameEn;
  final String nameTa;
  final String unit;
  final int rupees;
  final String category;
}
