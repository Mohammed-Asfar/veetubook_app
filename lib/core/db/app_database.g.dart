// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameTaMeta = const VerificationMeta('nameTa');
  @override
  late final GeneratedColumn<String> nameTa = GeneratedColumn<String>(
    'name_ta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameTa, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ta')) {
      context.handle(
        _nameTaMeta,
        nameTa.isAcceptableOrUnknown(data['name_ta']!, _nameTaMeta),
      );
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameTa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ta'],
      ),
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String? nameTa;
  final String? nameEn;
  const Category({required this.id, this.nameTa, this.nameEn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || nameTa != null) {
      map['name_ta'] = Variable<String>(nameTa);
    }
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      nameTa: nameTa == null && nullToAbsent
          ? const Value.absent()
          : Value(nameTa),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      nameTa: serializer.fromJson<String?>(json['nameTa']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameTa': serializer.toJson<String?>(nameTa),
      'nameEn': serializer.toJson<String?>(nameEn),
    };
  }

  Category copyWith({
    int? id,
    Value<String?> nameTa = const Value.absent(),
    Value<String?> nameEn = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    nameTa: nameTa.present ? nameTa.value : this.nameTa,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      nameTa: data.nameTa.present ? data.nameTa.value : this.nameTa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameTa, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.nameTa == this.nameTa &&
          other.nameEn == this.nameEn);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String?> nameTa;
  final Value<String?> nameEn;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.nameTa = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.nameTa = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? nameTa,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameTa != null) 'name_ta': nameTa,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? nameTa,
    Value<String?>? nameEn,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      nameTa: nameTa ?? this.nameTa,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameTa.present) {
      map['name_ta'] = Variable<String>(nameTa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameTaMeta = const VerificationMeta('nameTa');
  @override
  late final GeneratedColumn<String> nameTa = GeneratedColumn<String>(
    'name_ta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unit'),
  );
  static const VerificationMeta _baseQtyMeta = const VerificationMeta(
    'baseQty',
  );
  @override
  late final GeneratedColumn<String> baseQty = GeneratedColumn<String>(
    'base_qty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1'),
  );
  static const VerificationMeta _basePricePaiseMeta = const VerificationMeta(
    'basePricePaise',
  );
  @override
  late final GeneratedColumn<int> basePricePaise = GeneratedColumn<int>(
    'base_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameTa,
    nameEn,
    categoryId,
    unit,
    baseQty,
    basePricePaise,
    isDeleted,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ta')) {
      context.handle(
        _nameTaMeta,
        nameTa.isAcceptableOrUnknown(data['name_ta']!, _nameTaMeta),
      );
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('base_qty')) {
      context.handle(
        _baseQtyMeta,
        baseQty.isAcceptableOrUnknown(data['base_qty']!, _baseQtyMeta),
      );
    }
    if (data.containsKey('base_price_paise')) {
      context.handle(
        _basePricePaiseMeta,
        basePricePaise.isAcceptableOrUnknown(
          data['base_price_paise']!,
          _basePricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameTa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ta'],
      ),
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      baseQty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_qty'],
      )!,
      basePricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_price_paise'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String? nameTa;
  final String? nameEn;
  final int? categoryId;
  final String unit;

  /// Base quantity the [basePricePaise] applies to (e.g. 1 for ₹50/kg).
  /// Stored as text to preserve exact decimals (Decimal.parse).
  final String baseQty;

  /// Price (paise) for [baseQty] of this product.
  final int basePricePaise;

  /// Soft-delete so past expense snapshots stay intact when a product is
  /// removed (PRD edge case).
  final bool isDeleted;
  final DateTime? updatedAt;
  const Product({
    required this.id,
    this.nameTa,
    this.nameEn,
    this.categoryId,
    required this.unit,
    required this.baseQty,
    required this.basePricePaise,
    required this.isDeleted,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || nameTa != null) {
      map['name_ta'] = Variable<String>(nameTa);
    }
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['unit'] = Variable<String>(unit);
    map['base_qty'] = Variable<String>(baseQty);
    map['base_price_paise'] = Variable<int>(basePricePaise);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      nameTa: nameTa == null && nullToAbsent
          ? const Value.absent()
          : Value(nameTa),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      unit: Value(unit),
      baseQty: Value(baseQty),
      basePricePaise: Value(basePricePaise),
      isDeleted: Value(isDeleted),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      nameTa: serializer.fromJson<String?>(json['nameTa']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      unit: serializer.fromJson<String>(json['unit']),
      baseQty: serializer.fromJson<String>(json['baseQty']),
      basePricePaise: serializer.fromJson<int>(json['basePricePaise']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameTa': serializer.toJson<String?>(nameTa),
      'nameEn': serializer.toJson<String?>(nameEn),
      'categoryId': serializer.toJson<int?>(categoryId),
      'unit': serializer.toJson<String>(unit),
      'baseQty': serializer.toJson<String>(baseQty),
      'basePricePaise': serializer.toJson<int>(basePricePaise),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    Value<String?> nameTa = const Value.absent(),
    Value<String?> nameEn = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    String? unit,
    String? baseQty,
    int? basePricePaise,
    bool? isDeleted,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Product(
    id: id ?? this.id,
    nameTa: nameTa.present ? nameTa.value : this.nameTa,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    unit: unit ?? this.unit,
    baseQty: baseQty ?? this.baseQty,
    basePricePaise: basePricePaise ?? this.basePricePaise,
    isDeleted: isDeleted ?? this.isDeleted,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      nameTa: data.nameTa.present ? data.nameTa.value : this.nameTa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      unit: data.unit.present ? data.unit.value : this.unit,
      baseQty: data.baseQty.present ? data.baseQty.value : this.baseQty,
      basePricePaise: data.basePricePaise.present
          ? data.basePricePaise.value
          : this.basePricePaise,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('baseQty: $baseQty, ')
          ..write('basePricePaise: $basePricePaise, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameTa,
    nameEn,
    categoryId,
    unit,
    baseQty,
    basePricePaise,
    isDeleted,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.nameTa == this.nameTa &&
          other.nameEn == this.nameEn &&
          other.categoryId == this.categoryId &&
          other.unit == this.unit &&
          other.baseQty == this.baseQty &&
          other.basePricePaise == this.basePricePaise &&
          other.isDeleted == this.isDeleted &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String?> nameTa;
  final Value<String?> nameEn;
  final Value<int?> categoryId;
  final Value<String> unit;
  final Value<String> baseQty;
  final Value<int> basePricePaise;
  final Value<bool> isDeleted;
  final Value<DateTime?> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.nameTa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unit = const Value.absent(),
    this.baseQty = const Value.absent(),
    this.basePricePaise = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    this.nameTa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unit = const Value.absent(),
    this.baseQty = const Value.absent(),
    this.basePricePaise = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? nameTa,
    Expression<String>? nameEn,
    Expression<int>? categoryId,
    Expression<String>? unit,
    Expression<String>? baseQty,
    Expression<int>? basePricePaise,
    Expression<bool>? isDeleted,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameTa != null) 'name_ta': nameTa,
      if (nameEn != null) 'name_en': nameEn,
      if (categoryId != null) 'category_id': categoryId,
      if (unit != null) 'unit': unit,
      if (baseQty != null) 'base_qty': baseQty,
      if (basePricePaise != null) 'base_price_paise': basePricePaise,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String?>? nameTa,
    Value<String?>? nameEn,
    Value<int?>? categoryId,
    Value<String>? unit,
    Value<String>? baseQty,
    Value<int>? basePricePaise,
    Value<bool>? isDeleted,
    Value<DateTime?>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      nameTa: nameTa ?? this.nameTa,
      nameEn: nameEn ?? this.nameEn,
      categoryId: categoryId ?? this.categoryId,
      unit: unit ?? this.unit,
      baseQty: baseQty ?? this.baseQty,
      basePricePaise: basePricePaise ?? this.basePricePaise,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameTa.present) {
      map['name_ta'] = Variable<String>(nameTa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (baseQty.present) {
      map['base_qty'] = Variable<String>(baseQty.value);
    }
    if (basePricePaise.present) {
      map['base_price_paise'] = Variable<int>(basePricePaise.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('baseQty: $baseQty, ')
          ..write('basePricePaise: $basePricePaise, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GroceryListsTable extends GroceryLists
    with TableInfo<$GroceryListsTable, GroceryList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroceryListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    createdAt,
    status,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grocery_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroceryList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroceryList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroceryList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $GroceryListsTable createAlias(String alias) {
    return $GroceryListsTable(attachedDatabase, alias);
  }
}

class GroceryList extends DataClass implements Insertable<GroceryList> {
  final int id;
  final String title;
  final DateTime createdAt;

  /// 'active' | 'completed'
  final String status;
  final DateTime? updatedAt;
  const GroceryList({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.status,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  GroceryListsCompanion toCompanion(bool nullToAbsent) {
    return GroceryListsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      status: Value(status),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory GroceryList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroceryList(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  GroceryList copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    String? status,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => GroceryList(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  GroceryList copyWithCompanion(GroceryListsCompanion data) {
    return GroceryList(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroceryList(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, status, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroceryList &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt);
}

class GroceryListsCompanion extends UpdateCompanion<GroceryList> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> updatedAt;
  const GroceryListsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GroceryListsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<GroceryList> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GroceryListsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? updatedAt,
  }) {
    return GroceryListsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroceryListsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ListItemsTable extends ListItems
    with TableInfo<$ListItemsTable, ListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grocery_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _nameTaMeta = const VerificationMeta('nameTa');
  @override
  late final GeneratedColumn<String> nameTa = GeneratedColumn<String>(
    'name_ta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unit'),
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<String> qty = GeneratedColumn<String>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1'),
  );
  static const VerificationMeta _unitPricePaiseMeta = const VerificationMeta(
    'unitPricePaise',
  );
  @override
  late final GeneratedColumn<int> unitPricePaise = GeneratedColumn<int>(
    'unit_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _linePricePaiseMeta = const VerificationMeta(
    'linePricePaise',
  );
  @override
  late final GeneratedColumn<int> linePricePaise = GeneratedColumn<int>(
    'line_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPriceOverriddenMeta = const VerificationMeta(
    'isPriceOverridden',
  );
  @override
  late final GeneratedColumn<bool> isPriceOverridden = GeneratedColumn<bool>(
    'is_price_overridden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_price_overridden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isBoughtMeta = const VerificationMeta(
    'isBought',
  );
  @override
  late final GeneratedColumn<bool> isBought = GeneratedColumn<bool>(
    'is_bought',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bought" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    productId,
    nameTa,
    nameEn,
    unit,
    qty,
    unitPricePaise,
    linePricePaise,
    isPriceOverridden,
    isBought,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('name_ta')) {
      context.handle(
        _nameTaMeta,
        nameTa.isAcceptableOrUnknown(data['name_ta']!, _nameTaMeta),
      );
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    }
    if (data.containsKey('unit_price_paise')) {
      context.handle(
        _unitPricePaiseMeta,
        unitPricePaise.isAcceptableOrUnknown(
          data['unit_price_paise']!,
          _unitPricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('line_price_paise')) {
      context.handle(
        _linePricePaiseMeta,
        linePricePaise.isAcceptableOrUnknown(
          data['line_price_paise']!,
          _linePricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('is_price_overridden')) {
      context.handle(
        _isPriceOverriddenMeta,
        isPriceOverridden.isAcceptableOrUnknown(
          data['is_price_overridden']!,
          _isPriceOverriddenMeta,
        ),
      );
    }
    if (data.containsKey('is_bought')) {
      context.handle(
        _isBoughtMeta,
        isBought.isAcceptableOrUnknown(data['is_bought']!, _isBoughtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      nameTa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ta'],
      ),
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qty'],
      )!,
      unitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_paise'],
      )!,
      linePricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_price_paise'],
      )!,
      isPriceOverridden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_price_overridden'],
      )!,
      isBought: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bought'],
      )!,
    );
  }

  @override
  $ListItemsTable createAlias(String alias) {
    return $ListItemsTable(attachedDatabase, alias);
  }
}

class ListItem extends DataClass implements Insertable<ListItem> {
  final int id;
  final int listId;
  final int? productId;
  final String? nameTa;
  final String? nameEn;
  final String unit;

  /// Chosen quantity (exact decimal as text).
  final String qty;

  /// Snapshot of unit price in paise (basePrice / baseQty at add time).
  final int unitPricePaise;

  /// Auto = unitPrice * qty, but user-overridable.
  final int linePricePaise;
  final bool isPriceOverridden;
  final bool isBought;
  const ListItem({
    required this.id,
    required this.listId,
    this.productId,
    this.nameTa,
    this.nameEn,
    required this.unit,
    required this.qty,
    required this.unitPricePaise,
    required this.linePricePaise,
    required this.isPriceOverridden,
    required this.isBought,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    if (!nullToAbsent || nameTa != null) {
      map['name_ta'] = Variable<String>(nameTa);
    }
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    map['unit'] = Variable<String>(unit);
    map['qty'] = Variable<String>(qty);
    map['unit_price_paise'] = Variable<int>(unitPricePaise);
    map['line_price_paise'] = Variable<int>(linePricePaise);
    map['is_price_overridden'] = Variable<bool>(isPriceOverridden);
    map['is_bought'] = Variable<bool>(isBought);
    return map;
  }

  ListItemsCompanion toCompanion(bool nullToAbsent) {
    return ListItemsCompanion(
      id: Value(id),
      listId: Value(listId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      nameTa: nameTa == null && nullToAbsent
          ? const Value.absent()
          : Value(nameTa),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      unit: Value(unit),
      qty: Value(qty),
      unitPricePaise: Value(unitPricePaise),
      linePricePaise: Value(linePricePaise),
      isPriceOverridden: Value(isPriceOverridden),
      isBought: Value(isBought),
    );
  }

  factory ListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListItem(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      productId: serializer.fromJson<int?>(json['productId']),
      nameTa: serializer.fromJson<String?>(json['nameTa']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      unit: serializer.fromJson<String>(json['unit']),
      qty: serializer.fromJson<String>(json['qty']),
      unitPricePaise: serializer.fromJson<int>(json['unitPricePaise']),
      linePricePaise: serializer.fromJson<int>(json['linePricePaise']),
      isPriceOverridden: serializer.fromJson<bool>(json['isPriceOverridden']),
      isBought: serializer.fromJson<bool>(json['isBought']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'productId': serializer.toJson<int?>(productId),
      'nameTa': serializer.toJson<String?>(nameTa),
      'nameEn': serializer.toJson<String?>(nameEn),
      'unit': serializer.toJson<String>(unit),
      'qty': serializer.toJson<String>(qty),
      'unitPricePaise': serializer.toJson<int>(unitPricePaise),
      'linePricePaise': serializer.toJson<int>(linePricePaise),
      'isPriceOverridden': serializer.toJson<bool>(isPriceOverridden),
      'isBought': serializer.toJson<bool>(isBought),
    };
  }

  ListItem copyWith({
    int? id,
    int? listId,
    Value<int?> productId = const Value.absent(),
    Value<String?> nameTa = const Value.absent(),
    Value<String?> nameEn = const Value.absent(),
    String? unit,
    String? qty,
    int? unitPricePaise,
    int? linePricePaise,
    bool? isPriceOverridden,
    bool? isBought,
  }) => ListItem(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    productId: productId.present ? productId.value : this.productId,
    nameTa: nameTa.present ? nameTa.value : this.nameTa,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    unit: unit ?? this.unit,
    qty: qty ?? this.qty,
    unitPricePaise: unitPricePaise ?? this.unitPricePaise,
    linePricePaise: linePricePaise ?? this.linePricePaise,
    isPriceOverridden: isPriceOverridden ?? this.isPriceOverridden,
    isBought: isBought ?? this.isBought,
  );
  ListItem copyWithCompanion(ListItemsCompanion data) {
    return ListItem(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      productId: data.productId.present ? data.productId.value : this.productId,
      nameTa: data.nameTa.present ? data.nameTa.value : this.nameTa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      unit: data.unit.present ? data.unit.value : this.unit,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitPricePaise: data.unitPricePaise.present
          ? data.unitPricePaise.value
          : this.unitPricePaise,
      linePricePaise: data.linePricePaise.present
          ? data.linePricePaise.value
          : this.linePricePaise,
      isPriceOverridden: data.isPriceOverridden.present
          ? data.isPriceOverridden.value
          : this.isPriceOverridden,
      isBought: data.isBought.present ? data.isBought.value : this.isBought,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListItem(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('productId: $productId, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn, ')
          ..write('unit: $unit, ')
          ..write('qty: $qty, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('linePricePaise: $linePricePaise, ')
          ..write('isPriceOverridden: $isPriceOverridden, ')
          ..write('isBought: $isBought')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listId,
    productId,
    nameTa,
    nameEn,
    unit,
    qty,
    unitPricePaise,
    linePricePaise,
    isPriceOverridden,
    isBought,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListItem &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.productId == this.productId &&
          other.nameTa == this.nameTa &&
          other.nameEn == this.nameEn &&
          other.unit == this.unit &&
          other.qty == this.qty &&
          other.unitPricePaise == this.unitPricePaise &&
          other.linePricePaise == this.linePricePaise &&
          other.isPriceOverridden == this.isPriceOverridden &&
          other.isBought == this.isBought);
}

class ListItemsCompanion extends UpdateCompanion<ListItem> {
  final Value<int> id;
  final Value<int> listId;
  final Value<int?> productId;
  final Value<String?> nameTa;
  final Value<String?> nameEn;
  final Value<String> unit;
  final Value<String> qty;
  final Value<int> unitPricePaise;
  final Value<int> linePricePaise;
  final Value<bool> isPriceOverridden;
  final Value<bool> isBought;
  const ListItemsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.productId = const Value.absent(),
    this.nameTa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.unit = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.linePricePaise = const Value.absent(),
    this.isPriceOverridden = const Value.absent(),
    this.isBought = const Value.absent(),
  });
  ListItemsCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    this.productId = const Value.absent(),
    this.nameTa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.unit = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.linePricePaise = const Value.absent(),
    this.isPriceOverridden = const Value.absent(),
    this.isBought = const Value.absent(),
  }) : listId = Value(listId);
  static Insertable<ListItem> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<int>? productId,
    Expression<String>? nameTa,
    Expression<String>? nameEn,
    Expression<String>? unit,
    Expression<String>? qty,
    Expression<int>? unitPricePaise,
    Expression<int>? linePricePaise,
    Expression<bool>? isPriceOverridden,
    Expression<bool>? isBought,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (productId != null) 'product_id': productId,
      if (nameTa != null) 'name_ta': nameTa,
      if (nameEn != null) 'name_en': nameEn,
      if (unit != null) 'unit': unit,
      if (qty != null) 'qty': qty,
      if (unitPricePaise != null) 'unit_price_paise': unitPricePaise,
      if (linePricePaise != null) 'line_price_paise': linePricePaise,
      if (isPriceOverridden != null) 'is_price_overridden': isPriceOverridden,
      if (isBought != null) 'is_bought': isBought,
    });
  }

  ListItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? listId,
    Value<int?>? productId,
    Value<String?>? nameTa,
    Value<String?>? nameEn,
    Value<String>? unit,
    Value<String>? qty,
    Value<int>? unitPricePaise,
    Value<int>? linePricePaise,
    Value<bool>? isPriceOverridden,
    Value<bool>? isBought,
  }) {
    return ListItemsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      productId: productId ?? this.productId,
      nameTa: nameTa ?? this.nameTa,
      nameEn: nameEn ?? this.nameEn,
      unit: unit ?? this.unit,
      qty: qty ?? this.qty,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
      linePricePaise: linePricePaise ?? this.linePricePaise,
      isPriceOverridden: isPriceOverridden ?? this.isPriceOverridden,
      isBought: isBought ?? this.isBought,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (nameTa.present) {
      map['name_ta'] = Variable<String>(nameTa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (qty.present) {
      map['qty'] = Variable<String>(qty.value);
    }
    if (unitPricePaise.present) {
      map['unit_price_paise'] = Variable<int>(unitPricePaise.value);
    }
    if (linePricePaise.present) {
      map['line_price_paise'] = Variable<int>(linePricePaise.value);
    }
    if (isPriceOverridden.present) {
      map['is_price_overridden'] = Variable<bool>(isPriceOverridden.value);
    }
    if (isBought.present) {
      map['is_bought'] = Variable<bool>(isBought.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListItemsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('productId: $productId, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn, ')
          ..write('unit: $unit, ')
          ..write('qty: $qty, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('linePricePaise: $linePricePaise, ')
          ..write('isPriceOverridden: $isPriceOverridden, ')
          ..write('isBought: $isBought')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grocery_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPaiseMeta = const VerificationMeta(
    'totalPaise',
  );
  @override
  late final GeneratedColumn<int> totalPaise = GeneratedColumn<int>(
    'total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    date,
    totalPaise,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_paise')) {
      context.handle(
        _totalPaiseMeta,
        totalPaise.isAcceptableOrUnknown(data['total_paise']!, _totalPaiseMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      totalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_paise'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int listId;

  /// Trip date, stored UTC; reports bucket by local month.
  final DateTime date;

  /// Total (paise) of bought items on the trip.
  final int totalPaise;
  final DateTime? updatedAt;
  final bool isSynced;
  const Expense({
    required this.id,
    required this.listId,
    required this.date,
    required this.totalPaise,
    this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    map['date'] = Variable<DateTime>(date);
    map['total_paise'] = Variable<int>(totalPaise);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      listId: Value(listId),
      date: Value(date),
      totalPaise: Value(totalPaise),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'date': serializer.toJson<DateTime>(date),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Expense copyWith({
    int? id,
    int? listId,
    DateTime? date,
    int? totalPaise,
    Value<DateTime?> updatedAt = const Value.absent(),
    bool? isSynced,
  }) => Expense(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    date: date ?? this.date,
    totalPaise: totalPaise ?? this.totalPaise,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      date: data.date.present ? data.date.value : this.date,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('date: $date, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, listId, date, totalPaise, updatedAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.date == this.date &&
          other.totalPaise == this.totalPaise &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> listId;
  final Value<DateTime> date;
  final Value<int> totalPaise;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.date = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    required DateTime date,
    this.totalPaise = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : listId = Value(listId),
       date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<DateTime>? date,
    Expression<int>? totalPaise,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (date != null) 'date': date,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? listId,
    Value<DateTime>? date,
    Value<int>? totalPaise,
    Value<DateTime?>? updatedAt,
    Value<bool>? isSynced,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      date: date ?? this.date,
      totalPaise: totalPaise ?? this.totalPaise,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalPaise.present) {
      map['total_paise'] = Variable<int>(totalPaise.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('date: $date, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $GroceryListsTable groceryLists = $GroceryListsTable(this);
  late final $ListItemsTable listItems = $ListItemsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    products,
    groceryLists,
    listItems,
    expenses,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('products', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'grocery_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('list_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('list_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'grocery_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String?> nameTa,
      Value<String?> nameEn,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String?> nameTa,
      Value<String?> nameEn,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'categories__id__products__category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameTa =>
      $composableBuilder(column: $table.nameTa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool productsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nameTa = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
              }) => CategoriesCompanion(id: id, nameTa: nameTa, nameEn: nameEn),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nameTa = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                nameTa: nameTa,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      Product
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._productsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).productsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool productsRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String?> nameTa,
      Value<String?> nameEn,
      Value<int?> categoryId,
      Value<String> unit,
      Value<String> baseQty,
      Value<int> basePricePaise,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String?> nameTa,
      Value<String?> nameEn,
      Value<int?> categoryId,
      Value<String> unit,
      Value<String> baseQty,
      Value<int> basePricePaise,
      Value<bool> isDeleted,
      Value<DateTime?> updatedAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('products__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ListItemsTable, List<ListItem>>
  _listItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.listItems,
    aliasName: 'products__id__list_items__product_id',
  );

  $$ListItemsTableProcessedTableManager get listItemsRefs {
    final manager = $$ListItemsTableTableManager(
      $_db,
      $_db.listItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_listItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseQty => $composableBuilder(
    column: $table.baseQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get basePricePaise => $composableBuilder(
    column: $table.basePricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> listItemsRefs(
    Expression<bool> Function($$ListItemsTableFilterComposer f) f,
  ) {
    final $$ListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListItemsTableFilterComposer(
            $db: $db,
            $table: $db.listItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseQty => $composableBuilder(
    column: $table.baseQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get basePricePaise => $composableBuilder(
    column: $table.basePricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameTa =>
      $composableBuilder(column: $table.nameTa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get baseQty =>
      $composableBuilder(column: $table.baseQty, builder: (column) => column);

  GeneratedColumn<int> get basePricePaise => $composableBuilder(
    column: $table.basePricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> listItemsRefs<T extends Object>(
    Expression<T> Function($$ListItemsTableAnnotationComposer a) f,
  ) {
    final $$ListItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.listItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool categoryId, bool listItemsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nameTa = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> baseQty = const Value.absent(),
                Value<int> basePricePaise = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                nameTa: nameTa,
                nameEn: nameEn,
                categoryId: categoryId,
                unit: unit,
                baseQty: baseQty,
                basePricePaise: basePricePaise,
                isDeleted: isDeleted,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nameTa = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> baseQty = const Value.absent(),
                Value<int> basePricePaise = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                nameTa: nameTa,
                nameEn: nameEn,
                categoryId: categoryId,
                unit: unit,
                baseQty: baseQty,
                basePricePaise: basePricePaise,
                isDeleted: isDeleted,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, listItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (listItemsRefs) db.listItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$ProductsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$ProductsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listItemsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      ListItem
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._listItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).listItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool categoryId, bool listItemsRefs})
    >;
typedef $$GroceryListsTableCreateCompanionBuilder =
    GroceryListsCompanion Function({
      Value<int> id,
      required String title,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> updatedAt,
    });
typedef $$GroceryListsTableUpdateCompanionBuilder =
    GroceryListsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> updatedAt,
    });

final class $$GroceryListsTableReferences
    extends BaseReferences<_$AppDatabase, $GroceryListsTable, GroceryList> {
  $$GroceryListsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ListItemsTable, List<ListItem>>
  _listItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.listItems,
    aliasName: 'grocery_lists__id__list_items__list_id',
  );

  $$ListItemsTableProcessedTableManager get listItemsRefs {
    final manager = $$ListItemsTableTableManager(
      $_db,
      $_db.listItems,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_listItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'grocery_lists__id__expenses__list_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroceryListsTableFilterComposer
    extends Composer<_$AppDatabase, $GroceryListsTable> {
  $$GroceryListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> listItemsRefs(
    Expression<bool> Function($$ListItemsTableFilterComposer f) f,
  ) {
    final $$ListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listItems,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListItemsTableFilterComposer(
            $db: $db,
            $table: $db.listItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroceryListsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroceryListsTable> {
  $$GroceryListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroceryListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroceryListsTable> {
  $$GroceryListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> listItemsRefs<T extends Object>(
    Expression<T> Function($$ListItemsTableAnnotationComposer a) f,
  ) {
    final $$ListItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listItems,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.listItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroceryListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroceryListsTable,
          GroceryList,
          $$GroceryListsTableFilterComposer,
          $$GroceryListsTableOrderingComposer,
          $$GroceryListsTableAnnotationComposer,
          $$GroceryListsTableCreateCompanionBuilder,
          $$GroceryListsTableUpdateCompanionBuilder,
          (GroceryList, $$GroceryListsTableReferences),
          GroceryList,
          PrefetchHooks Function({bool listItemsRefs, bool expensesRefs})
        > {
  $$GroceryListsTableTableManager(_$AppDatabase db, $GroceryListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroceryListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroceryListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroceryListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => GroceryListsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                status: status,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => GroceryListsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                status: status,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroceryListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({listItemsRefs = false, expensesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (listItemsRefs) db.listItems,
                    if (expensesRefs) db.expenses,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (listItemsRefs)
                        await $_getPrefetchedData<
                          GroceryList,
                          $GroceryListsTable,
                          ListItem
                        >(
                          currentTable: table,
                          referencedTable: $$GroceryListsTableReferences
                              ._listItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroceryListsTableReferences(
                                db,
                                table,
                                p0,
                              ).listItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.listId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          GroceryList,
                          $GroceryListsTable,
                          Expense
                        >(
                          currentTable: table,
                          referencedTable: $$GroceryListsTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroceryListsTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.listId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroceryListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroceryListsTable,
      GroceryList,
      $$GroceryListsTableFilterComposer,
      $$GroceryListsTableOrderingComposer,
      $$GroceryListsTableAnnotationComposer,
      $$GroceryListsTableCreateCompanionBuilder,
      $$GroceryListsTableUpdateCompanionBuilder,
      (GroceryList, $$GroceryListsTableReferences),
      GroceryList,
      PrefetchHooks Function({bool listItemsRefs, bool expensesRefs})
    >;
typedef $$ListItemsTableCreateCompanionBuilder =
    ListItemsCompanion Function({
      Value<int> id,
      required int listId,
      Value<int?> productId,
      Value<String?> nameTa,
      Value<String?> nameEn,
      Value<String> unit,
      Value<String> qty,
      Value<int> unitPricePaise,
      Value<int> linePricePaise,
      Value<bool> isPriceOverridden,
      Value<bool> isBought,
    });
typedef $$ListItemsTableUpdateCompanionBuilder =
    ListItemsCompanion Function({
      Value<int> id,
      Value<int> listId,
      Value<int?> productId,
      Value<String?> nameTa,
      Value<String?> nameEn,
      Value<String> unit,
      Value<String> qty,
      Value<int> unitPricePaise,
      Value<int> linePricePaise,
      Value<bool> isPriceOverridden,
      Value<bool> isBought,
    });

final class $$ListItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ListItemsTable, ListItem> {
  $$ListItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroceryListsTable _listIdTable(_$AppDatabase db) =>
      db.groceryLists.createAlias('list_items__list_id__grocery_lists__id');

  $$GroceryListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$GroceryListsTableTableManager(
      $_db,
      $_db.groceryLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('list_items__product_id__products__id');

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ListItemsTable> {
  $$ListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linePricePaise => $composableBuilder(
    column: $table.linePricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPriceOverridden => $composableBuilder(
    column: $table.isPriceOverridden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBought => $composableBuilder(
    column: $table.isBought,
    builder: (column) => ColumnFilters(column),
  );

  $$GroceryListsTableFilterComposer get listId {
    final $$GroceryListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.groceryLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroceryListsTableFilterComposer(
            $db: $db,
            $table: $db.groceryLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ListItemsTable> {
  $$ListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linePricePaise => $composableBuilder(
    column: $table.linePricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPriceOverridden => $composableBuilder(
    column: $table.isPriceOverridden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBought => $composableBuilder(
    column: $table.isBought,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroceryListsTableOrderingComposer get listId {
    final $$GroceryListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.groceryLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroceryListsTableOrderingComposer(
            $db: $db,
            $table: $db.groceryLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListItemsTable> {
  $$ListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameTa =>
      $composableBuilder(column: $table.nameTa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get linePricePaise => $composableBuilder(
    column: $table.linePricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPriceOverridden => $composableBuilder(
    column: $table.isPriceOverridden,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBought =>
      $composableBuilder(column: $table.isBought, builder: (column) => column);

  $$GroceryListsTableAnnotationComposer get listId {
    final $$GroceryListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.groceryLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroceryListsTableAnnotationComposer(
            $db: $db,
            $table: $db.groceryLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListItemsTable,
          ListItem,
          $$ListItemsTableFilterComposer,
          $$ListItemsTableOrderingComposer,
          $$ListItemsTableAnnotationComposer,
          $$ListItemsTableCreateCompanionBuilder,
          $$ListItemsTableUpdateCompanionBuilder,
          (ListItem, $$ListItemsTableReferences),
          ListItem,
          PrefetchHooks Function({bool listId, bool productId})
        > {
  $$ListItemsTableTableManager(_$AppDatabase db, $ListItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String?> nameTa = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> qty = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> linePricePaise = const Value.absent(),
                Value<bool> isPriceOverridden = const Value.absent(),
                Value<bool> isBought = const Value.absent(),
              }) => ListItemsCompanion(
                id: id,
                listId: listId,
                productId: productId,
                nameTa: nameTa,
                nameEn: nameEn,
                unit: unit,
                qty: qty,
                unitPricePaise: unitPricePaise,
                linePricePaise: linePricePaise,
                isPriceOverridden: isPriceOverridden,
                isBought: isBought,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listId,
                Value<int?> productId = const Value.absent(),
                Value<String?> nameTa = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> qty = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> linePricePaise = const Value.absent(),
                Value<bool> isPriceOverridden = const Value.absent(),
                Value<bool> isBought = const Value.absent(),
              }) => ListItemsCompanion.insert(
                id: id,
                listId: listId,
                productId: productId,
                nameTa: nameTa,
                nameEn: nameEn,
                unit: unit,
                qty: qty,
                unitPricePaise: unitPricePaise,
                linePricePaise: linePricePaise,
                isPriceOverridden: isPriceOverridden,
                isBought: isBought,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ListItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable: $$ListItemsTableReferences
                                    ._listIdTable(db),
                                referencedColumn: $$ListItemsTableReferences
                                    ._listIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$ListItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$ListItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListItemsTable,
      ListItem,
      $$ListItemsTableFilterComposer,
      $$ListItemsTableOrderingComposer,
      $$ListItemsTableAnnotationComposer,
      $$ListItemsTableCreateCompanionBuilder,
      $$ListItemsTableUpdateCompanionBuilder,
      (ListItem, $$ListItemsTableReferences),
      ListItem,
      PrefetchHooks Function({bool listId, bool productId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required int listId,
      required DateTime date,
      Value<int> totalPaise,
      Value<DateTime?> updatedAt,
      Value<bool> isSynced,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<int> listId,
      Value<DateTime> date,
      Value<int> totalPaise,
      Value<DateTime?> updatedAt,
      Value<bool> isSynced,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroceryListsTable _listIdTable(_$AppDatabase db) =>
      db.groceryLists.createAlias('expenses__list_id__grocery_lists__id');

  $$GroceryListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$GroceryListsTableTableManager(
      $_db,
      $_db.groceryLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$GroceryListsTableFilterComposer get listId {
    final $$GroceryListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.groceryLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroceryListsTableFilterComposer(
            $db: $db,
            $table: $db.groceryLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroceryListsTableOrderingComposer get listId {
    final $$GroceryListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.groceryLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroceryListsTableOrderingComposer(
            $db: $db,
            $table: $db.groceryLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$GroceryListsTableAnnotationComposer get listId {
    final $$GroceryListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.groceryLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroceryListsTableAnnotationComposer(
            $db: $db,
            $table: $db.groceryLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool listId})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                listId: listId,
                date: date,
                totalPaise: totalPaise,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listId,
                required DateTime date,
                Value<int> totalPaise = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                listId: listId,
                date: date,
                totalPaise: totalPaise,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable: $$ExpensesTableReferences
                                    ._listIdTable(db),
                                referencedColumn: $$ExpensesTableReferences
                                    ._listIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool listId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$GroceryListsTableTableManager get groceryLists =>
      $$GroceryListsTableTableManager(_db, _db.groceryLists);
  $$ListItemsTableTableManager get listItems =>
      $$ListItemsTableTableManager(_db, _db.listItems);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
