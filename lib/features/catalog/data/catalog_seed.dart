import '../domain/catalog_repository.dart';
import 'catalog_dao.dart';

/// Seeds a starter catalog of common Tamil household grocery items on first
/// launch so the app is useful immediately (PRD suggestion). Runs only when the
/// catalog is empty.
class CatalogSeeder {
  const CatalogSeeder(this._repo, this._dao);

  final CatalogRepository _repo;
  final CatalogDao _dao;

  Future<void> seedIfEmpty() async {
    if (await _repo.productCount() > 0) return;

    // Insert everything in ONE transaction (categories + a batched product
    // insert) instead of ~240 awaited round-trips, so the first launch doesn't
    // stall the Products page.
    await _dao.seedCatalog(
      _seedCategories,
      [
        for (final p in _seedProducts)
          SeedProductRow(
            nameEn: p.nameEn,
            nameTa: p.nameTa,
            unit: p.unit,
            basePricePaise: p.rupees * 100,
            categoryEn: p.category,
          ),
      ],
    );
  }

  // (englishCategory, tamilCategory)
  static const List<(String, String)> _seedCategories = [
    ('Grains & Rice', 'தானியங்கள் & அரிசி'),
    ('Pulses & Dals', 'பருப்பு வகைகள்'),
    ('Oils & Ghee', 'எண்ணெய் & நெய்'),
    ('Spices', 'மசாலா பொருட்கள்'),
    ('Vegetables', 'காய்கறிகள்'),
    ('Fruits', 'பழங்கள்'),
    ('Dairy', 'பால் பொருட்கள்'),
    ('Non-Veg', 'அசைவம்'),
    ('Beverages', 'பானங்கள்'),
    ('Snacks', 'தின்பண்டங்கள்'),
    ('Ready-to-Cook', 'சமையல் தயார் பொருட்கள்'),
    ('Household', 'வீட்டு உபயோகம்'),
    ('Others', 'மற்றவை'),
  ];

  static const List<_SeedProduct> _seedProducts = [
    // ---- Grains & Rice ----
    _SeedProduct('Ponni Rice', 'பொன்னி அரிசி', 'kg', 60, 'Grains & Rice'),
    _SeedProduct('Idli Rice', 'இட்லி அரிசி', 'kg', 55, 'Grains & Rice'),
    _SeedProduct('Basmati Rice', 'பாஸ்மதி அரிசி', 'kg', 120, 'Grains & Rice'),
    _SeedProduct('Wheat Flour', 'கோதுமை மாவு', 'kg', 45, 'Grains & Rice'),
    _SeedProduct('Maida', 'மைதா', 'kg', 45, 'Grains & Rice'),
    _SeedProduct('Rava / Sooji', 'ரவை', 'kg', 50, 'Grains & Rice'),
    _SeedProduct('Poha / Aval', 'அவல்', 'kg', 60, 'Grains & Rice'),
    _SeedProduct('Ragi Flour', 'கேழ்வரகு மாவு', 'kg', 70, 'Grains & Rice'),
    _SeedProduct('Oats', 'ஓட்ஸ்', 'kg', 150, 'Grains & Rice'),
    _SeedProduct('Sona Masoori Rice', 'சோனா மசூரி அரிசி', 'kg', 55, 'Grains & Rice'),
    _SeedProduct('Red Rice (Matta)', 'சிவப்பு அரிசி', 'kg', 65, 'Grains & Rice'),
    _SeedProduct('Boiled Rice', 'புழுங்கல் அரிசி', 'kg', 52, 'Grains & Rice'),
    _SeedProduct('Rice Flour', 'அரிசி மாவு', 'kg', 50, 'Grains & Rice'),
    _SeedProduct('Gram Flour (Besan)', 'கடலை மாவு', 'kg', 90, 'Grains & Rice'),
    _SeedProduct('Broken Wheat', 'கோதுமை ரவை', 'kg', 55, 'Grains & Rice'),
    _SeedProduct('Puttu Podi', 'புட்டு மாவு', 'kg', 60, 'Grains & Rice'),
    _SeedProduct('Pearl Millet (Kambu)', 'கம்பு', 'kg', 70, 'Grains & Rice'),
    _SeedProduct('Foxtail Millet (Thinai)', 'தினை', 'kg', 90, 'Grains & Rice'),
    _SeedProduct('Little Millet (Samai)', 'சாமை', 'kg', 90, 'Grains & Rice'),
    _SeedProduct('Sorghum (Cholam)', 'சோளம்', 'kg', 60, 'Grains & Rice'),

    // ---- Pulses & Dals ----
    _SeedProduct('Toor Dal', 'துவரம் பருப்பு', 'kg', 140, 'Pulses & Dals'),
    _SeedProduct('Moong Dal', 'பாசிப் பருப்பு', 'kg', 120, 'Pulses & Dals'),
    _SeedProduct('Urad Dal', 'உளுந்து', 'kg', 130, 'Pulses & Dals'),
    _SeedProduct('Channa Dal', 'கடலை பருப்பு', 'kg', 90, 'Pulses & Dals'),
    _SeedProduct('Green Gram', 'பச்சை பயறு', 'kg', 110, 'Pulses & Dals'),
    _SeedProduct('Chickpeas / Kabuli', 'கொண்டைக்கடலை', 'kg', 100, 'Pulses & Dals'),
    _SeedProduct('Rajma', 'ராஜ்மா', 'kg', 140, 'Pulses & Dals'),
    _SeedProduct('Black Gram Whole', 'முழு உளுந்து', 'kg', 130, 'Pulses & Dals'),
    _SeedProduct('Masoor Dal', 'மைசூர் பருப்பு', 'kg', 110, 'Pulses & Dals'),
    _SeedProduct('Groundnut', 'நிலக்கடலை', 'kg', 120, 'Pulses & Dals'),
    _SeedProduct('Soya Chunks', 'சோயா', 'kg', 130, 'Pulses & Dals'),
    _SeedProduct('Horse Gram', 'கொள்ளு', 'kg', 90, 'Pulses & Dals'),
    _SeedProduct('Black-Eyed Peas', 'காராமணி', 'kg', 120, 'Pulses & Dals'),
    _SeedProduct('Field Beans (Mochai)', 'மொச்சை', 'kg', 130, 'Pulses & Dals'),
    _SeedProduct('Dried Green Peas', 'பட்டாணி (உலர்)', 'kg', 100, 'Pulses & Dals'),

    // ---- Oils & Ghee ----
    _SeedProduct('Sunflower Oil', 'சூரியகாந்தி எண்ணெய்', 'litre', 130, 'Oils & Ghee'),
    _SeedProduct('Gingelly Oil', 'நல்லெண்ணெய்', 'litre', 250, 'Oils & Ghee'),
    _SeedProduct('Ghee', 'நெய்', 'litre', 600, 'Oils & Ghee'),
    _SeedProduct('Coconut Oil', 'தேங்காய் எண்ணெய்', 'litre', 220, 'Oils & Ghee'),
    _SeedProduct('Groundnut Oil', 'கடலை எண்ணெய்', 'litre', 200, 'Oils & Ghee'),
    _SeedProduct('Mustard Oil', 'கடுகு எண்ணெய்', 'litre', 180, 'Oils & Ghee'),

    // ---- Spices (whole, seeds & masala powders) ----
    _SeedProduct('Salt', 'உப்பு', 'kg', 20, 'Spices'),
    _SeedProduct('Rock Salt', 'இந்துப்பு', 'kg', 40, 'Spices'),
    _SeedProduct('Red Chilli Powder', 'மிளகாய் தூள்', 'kg', 300, 'Spices'),
    _SeedProduct('Turmeric Powder', 'மஞ்சள் தூள்', 'kg', 200, 'Spices'),
    _SeedProduct('Coriander Powder', 'மல்லி தூள்', 'kg', 180, 'Spices'),
    _SeedProduct('Pepper Powder', 'மிளகு தூள்', 'kg', 700, 'Spices'),
    _SeedProduct('Cumin Powder', 'சீரக தூள்', 'kg', 400, 'Spices'),
    _SeedProduct('Garam Masala', 'கரம் மசாலா', 'kg', 500, 'Spices'),
    _SeedProduct('Sambar Powder', 'சாம்பார் தூள்', 'kg', 320, 'Spices'),
    _SeedProduct('Rasam Powder', 'ரசம் தூள்', 'kg', 320, 'Spices'),
    _SeedProduct('Chicken Masala', 'சிக்கன் மசாலா', 'unit', 60, 'Spices'),
    _SeedProduct('Biryani Masala', 'பிரியாணி மசாலா', 'unit', 60, 'Spices'),
    _SeedProduct('Dry Mango Powder', 'மாங்காய் தூள்', 'kg', 300, 'Spices'),
    _SeedProduct('Red Chillies (dry)', 'மிளகாய் வத்தல்', 'kg', 320, 'Spices'),
    _SeedProduct('Mustard Seeds', 'கடுகு', 'kg', 120, 'Spices'),
    _SeedProduct('Cumin Seeds', 'சீரகம்', 'kg', 300, 'Spices'),
    _SeedProduct('Black Cumin', 'கருஞ்சீரகம்', 'kg', 400, 'Spices'),
    _SeedProduct('Fenugreek Seeds', 'வெந்தயம்', 'kg', 150, 'Spices'),
    _SeedProduct('Fennel Seeds', 'சோம்பு', 'kg', 300, 'Spices'),
    _SeedProduct('Carom Seeds', 'ஓமம்', 'kg', 350, 'Spices'),
    _SeedProduct('Coriander Seeds', 'கொத்தமல்லி விதை', 'kg', 180, 'Spices'),
    _SeedProduct('Peppercorns', 'மிளகு', 'kg', 600, 'Spices'),
    _SeedProduct('Poppy Seeds', 'கசகசா', 'kg', 1500, 'Spices'),
    _SeedProduct('Sesame Seeds', 'எள்ளு', 'kg', 200, 'Spices'),
    _SeedProduct('Cardamom', 'ஏலக்காய்', 'kg', 2500, 'Spices'),
    _SeedProduct('Cloves', 'கிராம்பு', 'kg', 900, 'Spices'),
    _SeedProduct('Cinnamon', 'பட்டை', 'kg', 700, 'Spices'),
    _SeedProduct('Bay Leaf', 'பிரிஞ்சி இலை', 'unit', 20, 'Spices'),
    _SeedProduct('Star Anise', 'அன்னாசி பூ', 'unit', 30, 'Spices'),
    _SeedProduct('Nutmeg', 'ஜாதிக்காய்', 'kg', 1500, 'Spices'),
    _SeedProduct('Mace', 'ஜாதிபத்திரி', 'kg', 2000, 'Spices'),
    _SeedProduct('Dry Ginger', 'சுக்கு', 'kg', 400, 'Spices'),
    _SeedProduct('Saffron', 'குங்குமப்பூ', 'unit', 150, 'Spices'),
    _SeedProduct('Asafoetida', 'பெருங்காயம்', 'unit', 40, 'Spices'),
    _SeedProduct('Tamarind', 'புளி', 'kg', 120, 'Spices'),

    // ---- Vegetables ----
    _SeedProduct('Onion', 'வெங்காயம்', 'kg', 30, 'Vegetables'),
    _SeedProduct('Small Onion', 'சின்ன வெங்காயம்', 'kg', 80, 'Vegetables'),
    _SeedProduct('Tomato', 'தக்காளி', 'kg', 25, 'Vegetables'),
    _SeedProduct('Potato', 'உருளைக்கிழங்கு', 'kg', 30, 'Vegetables'),
    _SeedProduct('Green Chilli', 'பச்சை மிளகாய்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Garlic', 'பூண்டு', 'kg', 120, 'Vegetables'),
    _SeedProduct('Ginger', 'இஞ்சி', 'kg', 80, 'Vegetables'),
    _SeedProduct('Curry Leaves', 'கறிவேப்பிலை', 'bunch', 10, 'Vegetables'),
    _SeedProduct('Coriander Leaves', 'கொத்தமல்லி', 'bunch', 10, 'Vegetables'),
    _SeedProduct('Mint Leaves', 'புதினா', 'bunch', 10, 'Vegetables'),
    _SeedProduct('Carrot', 'கேரட்', 'kg', 50, 'Vegetables'),
    _SeedProduct('Beans', 'பீன்ஸ்', 'kg', 60, 'Vegetables'),
    _SeedProduct('Brinjal', 'கத்தரிக்காய்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Lady Finger', 'வெண்டைக்காய்', 'kg', 50, 'Vegetables'),
    _SeedProduct('Cabbage', 'முட்டைகோஸ்', 'kg', 30, 'Vegetables'),
    _SeedProduct('Cauliflower', 'காலிஃபிளவர்', 'piece', 30, 'Vegetables'),
    _SeedProduct('Capsicum', 'குடமிளகாய்', 'kg', 60, 'Vegetables'),
    _SeedProduct('Beetroot', 'பீட்ரூட்', 'kg', 45, 'Vegetables'),
    _SeedProduct('Bottle Gourd', 'சுரைக்காய்', 'kg', 35, 'Vegetables'),
    _SeedProduct('Ridge Gourd', 'பீர்க்கங்காய்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Snake Gourd', 'புடலங்காய்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Bitter Gourd', 'பாகற்காய்', 'kg', 50, 'Vegetables'),
    _SeedProduct('Drumstick', 'முருங்கைக்காய்', 'kg', 60, 'Vegetables'),
    _SeedProduct('Cucumber', 'வெள்ளரிக்காய்', 'kg', 30, 'Vegetables'),
    _SeedProduct('Spinach', 'கீரை', 'bunch', 15, 'Vegetables'),
    _SeedProduct('Green Peas', 'பட்டாணி', 'kg', 100, 'Vegetables'),
    _SeedProduct('Sweet Potato', 'சர்க்கரைவள்ளிக்கிழங்கு', 'kg', 50, 'Vegetables'),
    _SeedProduct('Raw Banana', 'வாழைக்காய்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Coconut', 'தேங்காய்', 'piece', 30, 'Vegetables'),
    _SeedProduct('Radish', 'முள்ளங்கி', 'kg', 35, 'Vegetables'),
    _SeedProduct('Ash Gourd', 'பூசணிக்காய்', 'kg', 30, 'Vegetables'),
    _SeedProduct('Pumpkin', 'பரங்கிக்காய்', 'kg', 30, 'Vegetables'),
    _SeedProduct('Cluster Beans', 'கொத்தவரங்காய்', 'kg', 60, 'Vegetables'),
    _SeedProduct('Broad Beans', 'அவரைக்காய்', 'kg', 55, 'Vegetables'),
    _SeedProduct('Colocasia', 'சேப்பங்கிழங்கு', 'kg', 50, 'Vegetables'),
    _SeedProduct('Yam', 'சேனைக்கிழங்கு', 'kg', 55, 'Vegetables'),
    _SeedProduct('Tapioca', 'மரவள்ளிக்கிழங்கு', 'kg', 40, 'Vegetables'),
    _SeedProduct('Amaranth Leaves', 'முளைக்கீரை', 'bunch', 15, 'Vegetables'),
    _SeedProduct('Banana Stem', 'வாழைத்தண்டு', 'piece', 25, 'Vegetables'),
    _SeedProduct('Banana Flower', 'வாழைப்பூ', 'piece', 25, 'Vegetables'),
    _SeedProduct('Mushroom', 'காளான்', 'pack', 40, 'Vegetables'),
    _SeedProduct('Spring Onion', 'வெங்காயத்தால்', 'bunch', 20, 'Vegetables'),
    _SeedProduct('Lemon', 'எலுமிச்சை', 'dozen', 30, 'Vegetables'),
    _SeedProduct('Broccoli', 'ப்ரோக்கோலி', 'piece', 40, 'Vegetables'),
    _SeedProduct('Knol Khol', 'நூல்கோல்', 'kg', 40, 'Vegetables'),
    _SeedProduct('Ivy Gourd', 'கோவைக்காய்', 'kg', 45, 'Vegetables'),

    // ---- Fruits ----
    _SeedProduct('Banana', 'வாழைப்பழம்', 'dozen', 60, 'Fruits'),
    _SeedProduct('Apple', 'ஆப்பிள்', 'kg', 180, 'Fruits'),
    _SeedProduct('Orange', 'ஆரஞ்சு', 'kg', 80, 'Fruits'),
    _SeedProduct('Mango', 'மாம்பழம்', 'kg', 100, 'Fruits'),
    _SeedProduct('Grapes', 'திராட்சை', 'kg', 90, 'Fruits'),
    _SeedProduct('Pomegranate', 'மாதுளை', 'kg', 150, 'Fruits'),
    _SeedProduct('Watermelon', 'தர்பூசணி', 'kg', 25, 'Fruits'),
    _SeedProduct('Papaya', 'பப்பாளி', 'kg', 40, 'Fruits'),
    _SeedProduct('Guava', 'கொய்யா', 'kg', 60, 'Fruits'),
    _SeedProduct('Sweet Lime', 'சாத்துக்குடி', 'kg', 70, 'Fruits'),
    _SeedProduct('Pineapple', 'அன்னாசி', 'piece', 40, 'Fruits'),
    _SeedProduct('Sapota', 'சப்போட்டா', 'kg', 60, 'Fruits'),
    _SeedProduct('Custard Apple', 'சீதாப்பழம்', 'kg', 100, 'Fruits'),
    _SeedProduct('Jackfruit', 'பலாப்பழம்', 'kg', 60, 'Fruits'),
    _SeedProduct('Muskmelon', 'முலாம்பழம்', 'kg', 40, 'Fruits'),
    _SeedProduct('Pear', 'பேரிக்காய்', 'kg', 120, 'Fruits'),
    _SeedProduct('Kiwi', 'கிவி', 'piece', 30, 'Fruits'),
    _SeedProduct('Jamun', 'நாவல் பழம்', 'kg', 120, 'Fruits'),
    _SeedProduct('Fig', 'அத்திப்பழம்', 'kg', 150, 'Fruits'),
    _SeedProduct('Wood Apple', 'விளாம்பழம்', 'piece', 30, 'Fruits'),

    // ---- Dairy ----
    _SeedProduct('Milk', 'பால்', 'litre', 48, 'Dairy'),
    _SeedProduct('Curd', 'தயிர்', 'kg', 60, 'Dairy'),
    _SeedProduct('Butter', 'வெண்ணெய்', 'pack', 55, 'Dairy'),
    _SeedProduct('Paneer', 'பன்னீர்', 'kg', 350, 'Dairy'),
    _SeedProduct('Cheese', 'சீஸ்', 'pack', 120, 'Dairy'),
    _SeedProduct('Buttermilk', 'மோர்', 'litre', 30, 'Dairy'),
    _SeedProduct('Khoa', 'கோவா', 'kg', 300, 'Dairy'),

    // ---- Non-Veg ----
    _SeedProduct('Chicken', 'கோழி இறைச்சி', 'kg', 220, 'Non-Veg'),
    _SeedProduct('Country Chicken', 'நாட்டுக்கோழி', 'kg', 400, 'Non-Veg'),
    _SeedProduct('Mutton', 'ஆட்டிறைச்சி', 'kg', 800, 'Non-Veg'),
    _SeedProduct('Fish', 'மீன்', 'kg', 300, 'Non-Veg'),
    _SeedProduct('Prawns', 'இறால்', 'kg', 500, 'Non-Veg'),
    _SeedProduct('Eggs', 'முட்டை', 'dozen', 72, 'Non-Veg'),

    // ---- Beverages ----
    _SeedProduct('Tea Powder', 'தேயிலை தூள்', 'kg', 400, 'Beverages'),
    _SeedProduct('Coffee Powder', 'காபி தூள்', 'kg', 500, 'Beverages'),
    _SeedProduct('Boost / Horlicks', 'பூஸ்ட்', 'pack', 250, 'Beverages'),
    _SeedProduct('Green Tea', 'கிரீன் டீ', 'pack', 200, 'Beverages'),
    _SeedProduct('Drinking Water Can', 'குடிநீர் கேன்', 'unit', 40, 'Beverages'),
    _SeedProduct('Soft Drink', 'குளிர்பானம்', 'unit', 40, 'Beverages'),
    _SeedProduct('Fruit Juice', 'பழச்சாறு', 'unit', 90, 'Beverages'),
    _SeedProduct('Rose Milk Syrup', 'ரோஸ் மில்க்', 'unit', 150, 'Beverages'),

    // ---- Snacks ----
    _SeedProduct('Biscuits', 'பிஸ்கட்', 'pack', 30, 'Snacks'),
    _SeedProduct('Rusk', 'ரஸ்க்', 'pack', 45, 'Snacks'),
    _SeedProduct('Chips', 'சிப்ஸ்', 'pack', 20, 'Snacks'),
    _SeedProduct('Mixture', 'மிக்சர்', 'kg', 250, 'Snacks'),
    _SeedProduct('Murukku', 'முறுக்கு', 'kg', 300, 'Snacks'),
    _SeedProduct('Groundnut Candy', 'கடலை மிட்டாய்', 'pack', 40, 'Snacks'),
    _SeedProduct('Chocolate', 'சாக்லேட்', 'unit', 20, 'Snacks'),
    _SeedProduct('Noodles', 'நூடுல்ஸ்', 'pack', 15, 'Snacks'),
    _SeedProduct('Cornflakes', 'கார்ன்ஃப்ளேக்ஸ்', 'pack', 180, 'Snacks'),
    _SeedProduct('Popcorn', 'பாப்கார்ன்', 'pack', 40, 'Snacks'),

    // ---- Ready-to-Cook / Cooking items ----
    _SeedProduct('Idli/Dosa Batter', 'இட்லி/தோசை மாவு', 'kg', 60, 'Ready-to-Cook'),
    _SeedProduct('Idli Podi', 'இட்லி பொடி', 'pack', 80, 'Ready-to-Cook'),
    _SeedProduct('Ginger Garlic Paste', 'இஞ்சி பூண்டு விழுது', 'unit', 60, 'Ready-to-Cook'),
    _SeedProduct('Tomato Puree', 'தக்காளி விழுது', 'unit', 50, 'Ready-to-Cook'),
    _SeedProduct('Coconut Milk', 'தேங்காய் பால்', 'unit', 70, 'Ready-to-Cook'),
    _SeedProduct('Instant Rava Idli Mix', 'ரவா இட்லி மிக்ஸ்', 'pack', 70, 'Ready-to-Cook'),
    _SeedProduct('Dosa Mix', 'தோசை மிக்ஸ்', 'pack', 70, 'Ready-to-Cook'),
    _SeedProduct('Vada Mix', 'வடை மிக்ஸ்', 'pack', 70, 'Ready-to-Cook'),
    _SeedProduct('Gulab Jamun Mix', 'குலாப் ஜாமூன் மிக்ஸ்', 'pack', 90, 'Ready-to-Cook'),
    _SeedProduct('Payasam Mix', 'பாயசம் மிக்ஸ்', 'pack', 80, 'Ready-to-Cook'),
    _SeedProduct('Sambar Mix', 'சாம்பார் மிக்ஸ்', 'pack', 60, 'Ready-to-Cook'),
    _SeedProduct('Bajji/Bonda Mix', 'பஜ்ஜி மிக்ஸ்', 'pack', 60, 'Ready-to-Cook'),
    _SeedProduct('Appalam / Fryums', 'அப்பளம் / வத்தல்', 'pack', 50, 'Ready-to-Cook'),
    _SeedProduct('Pasta', 'பாஸ்தா', 'pack', 60, 'Ready-to-Cook'),
    _SeedProduct('Corn Flour', 'சோள மாவு', 'kg', 80, 'Ready-to-Cook'),
    _SeedProduct('Baking Powder', 'பேக்கிங் பவுடர்', 'unit', 40, 'Ready-to-Cook'),
    _SeedProduct('Eno / Fruit Salt', 'ஈனோ', 'unit', 30, 'Ready-to-Cook'),
    _SeedProduct('Food Colour', 'உணவு வண்ணம்', 'unit', 30, 'Ready-to-Cook'),
    _SeedProduct('Rose/Vanilla Essence', 'எசென்ஸ்', 'unit', 40, 'Ready-to-Cook'),

    // ---- Household ----
    _SeedProduct('Bath Soap', 'குளியல் சோப்பு', 'unit', 40, 'Household'),
    _SeedProduct('Detergent Powder', 'சலவை தூள்', 'kg', 120, 'Household'),
    _SeedProduct('Dishwash Liquid', 'பாத்திரம் கழுவும் திரவம்', 'unit', 100, 'Household'),
    _SeedProduct('Toothpaste', 'பற்பசை', 'unit', 90, 'Household'),
    _SeedProduct('Shampoo', 'ஷாம்பு', 'unit', 150, 'Household'),
    _SeedProduct('Hair Oil', 'தலை எண்ணெய்', 'unit', 120, 'Household'),
    _SeedProduct('Floor Cleaner', 'தரை சுத்தம் செய்யும் திரவம்', 'unit', 110, 'Household'),
    _SeedProduct('Toilet Cleaner', 'கழிப்பறை கிளீனர்', 'unit', 90, 'Household'),
    _SeedProduct('Agarbatti', 'ஊதுபத்தி', 'pack', 40, 'Household'),
    _SeedProduct('Match Box', 'தீப்பெட்டி', 'unit', 5, 'Household'),
    _SeedProduct('Toilet Paper', 'டாய்லெட் பேப்பர்', 'pack', 80, 'Household'),
    _SeedProduct('Garbage Bags', 'குப்பை பைகள்', 'pack', 60, 'Household'),
    _SeedProduct('Phenyl', 'ஃபினைல்', 'litre', 90, 'Household'),
    _SeedProduct('Mosquito Coil', 'கொசு சுருள்', 'pack', 40, 'Household'),
    _SeedProduct('Handwash', 'கைகழுவு திரவம்', 'unit', 90, 'Household'),
    _SeedProduct('Aluminium Foil', 'அலுமினியம் ஃபாயில்', 'unit', 80, 'Household'),

    // ---- Others ----
    _SeedProduct('Sugar', 'சர்க்கரை', 'kg', 45, 'Others'),
    _SeedProduct('Jaggery', 'வெல்லம்', 'kg', 70, 'Others'),
    _SeedProduct('Bread', 'பிரெட்', 'pack', 45, 'Others'),
    _SeedProduct('Honey', 'தேன்', 'unit', 250, 'Others'),
    _SeedProduct('Papad', 'அப்பளம்', 'pack', 50, 'Others'),
    _SeedProduct('Pickle', 'ஊறுகாய்', 'unit', 90, 'Others'),
    _SeedProduct('Sauce / Ketchup', 'தக்காளி சாஸ்', 'unit', 100, 'Others'),
    _SeedProduct('Jam', 'ஜாம்', 'unit', 150, 'Others'),
    _SeedProduct('Vinegar', 'வினிகர்', 'unit', 50, 'Others'),
    _SeedProduct('Baking Soda', 'சமையல் சோடா', 'unit', 30, 'Others'),
    _SeedProduct('Dry Coconut (Copra)', 'கொப்பரை', 'kg', 250, 'Others'),
    _SeedProduct('Cashew', 'முந்திரி', 'kg', 800, 'Others'),
    _SeedProduct('Almonds', 'பாதாம்', 'kg', 700, 'Others'),
    _SeedProduct('Raisins', 'திராட்சை உலர்ந்தது', 'kg', 300, 'Others'),
    _SeedProduct('Dates', 'பேரிச்சம்பழம்', 'kg', 200, 'Others'),
    _SeedProduct('Walnut', 'அக்ரூட்', 'kg', 900, 'Others'),
    _SeedProduct('Pistachio', 'பிஸ்தா', 'kg', 1200, 'Others'),
    _SeedProduct('Dry Dates', 'உலர் பேரீச்சை', 'kg', 250, 'Others'),
    _SeedProduct('Apricot', 'சுக்குப் பாதாம்', 'kg', 600, 'Others'),
    _SeedProduct('Fox Nut (Makhana)', 'மகானா', 'pack', 150, 'Others'),
    _SeedProduct('Pumpkin Seeds', 'பூசணி விதை', 'pack', 120, 'Others'),
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
