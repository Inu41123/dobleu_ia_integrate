class ChatItemModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image1;
  final int generalCategoryId;
  final String restaurantName;
  final int restaurantId;

  ChatItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image1,
    required this.generalCategoryId,
    required this.restaurantName,
    required this.restaurantId,
  });

  factory ChatItemModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      } else if (json['price'] is String) {
        String pStr = json['price'].toString().replaceAll('\$', '').replaceAll(',', '');
        parsedPrice = double.tryParse(pStr) ?? 0.0;
      }
    }

    return ChatItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? json['desc'] ?? '',
      price: parsedPrice,
      image1: json['image1'] ?? '',
      generalCategoryId: json['general_category_id'] ?? 0,
      restaurantName: json['restaurant_name'] ?? json['negocio'] ?? '',
      restaurantId: json['restaurant_id'] ?? 0,
    );
  }
}

class ChatBusinessModel {
  final String name;
  final bool? abierto;
  final List<ChatItemModel> items;

  ChatBusinessModel({
    required this.name,
    this.abierto,
    required this.items,
  });

  factory ChatBusinessModel.fromJson(Map<String, dynamic> json, [List<dynamic> matchesList = const []]) {
    var itemsList = json['items'] as List? ?? [];
    String bizName = json['name'] ?? '';
    
    List<ChatItemModel> parsedItems = itemsList.map((i) {
      // Intentamos enriquecer este item visual (que no trae ID) con los datos del arreglo 'matches'
      String itemName = i['name']?.toString() ?? '';
      String itemBiz = i['negocio']?.toString() ?? i['restaurant_name']?.toString() ?? bizName;
      
      Map<String, dynamic>? realMatch;
      for (var m in matchesList) {
        if (m is! Map<String, dynamic>) continue;
        String mName = m['name']?.toString() ?? '';
        String mClean = m['_clean_name']?.toString() ?? '';
        String mBiz = m['restaurant_name']?.toString() ?? '';
        
        bool nameMatches = mName.toLowerCase() == itemName.toLowerCase() || 
                           mClean.toLowerCase() == itemName.toLowerCase();
                           
        bool bizMatches = itemBiz.isEmpty || 
                          itemBiz.toLowerCase() == 'top dobleu' || 
                          itemBiz.toLowerCase() == 'opciones encontradas' ||
                          mBiz.toLowerCase() == itemBiz.toLowerCase();
                          
        if (nameMatches && bizMatches) {
          realMatch = m;
          break;
        }
      }
      
      // Si encontramos el item en 'matches', le inyectamos los IDs a este JSON antes de parsearlo
      if (realMatch != null) {
        i['id'] = realMatch['id'];
        i['restaurant_id'] = realMatch['restaurant_id'];
        if (i['restaurant_name'] == null && i['negocio'] == null) {
          i['restaurant_name'] = realMatch['restaurant_name'];
        }
      }
      
      return ChatItemModel.fromJson(i as Map<String, dynamic>);
    }).toList();
    
    return ChatBusinessModel(
      name: bizName,
      abierto: json['abierto'],
      items: parsedItems,
    );
  }
}

class ChatResponseModel {
  final String type;
  final String? source;
  final String? categoryDetected;
  final String? mealContext;
  final String? horaNota;
  final String? correction;
  final String? title;
  final String? ollamaIntro;
  final bool? isGlobal;
  final List<ChatBusinessModel>? businesses;
  final String? answer;

  ChatResponseModel({
    required this.type,
    this.source,
    this.categoryDetected,
    this.mealContext,
    this.horaNota,
    this.correction,
    this.title,
    this.ollamaIntro,
    this.isGlobal,
    this.businesses,
    this.answer,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    // El arreglo 'matches' es el que contiene la información completa con los IDs
    var matchesList = json['matches'] as List? ?? [];

    var bizList = json['businesses'] as List?;
    List<ChatBusinessModel>? parsedBusinesses;
    if (bizList != null) {
      parsedBusinesses = bizList.map((b) => ChatBusinessModel.fromJson(b, matchesList)).toList();
    } else if (json['structured'] != null && json['structured']['businesses'] != null) {
      bizList = json['structured']['businesses'] as List?;
      if (bizList != null) {
        parsedBusinesses = bizList.map((b) => ChatBusinessModel.fromJson(b, matchesList)).toList();
      }
    }

    var root = json['structured'] ?? json;

    return ChatResponseModel(
      type: root['type'] ?? 'results',
      source: root['source'],
      categoryDetected: root['category_detected'],
      mealContext: root['meal_context'],
      horaNota: root['hora_nota'],
      correction: root['correction'],
      title: root['title'],
      ollamaIntro: root['ollama_intro'],
      isGlobal: root['is_global'],
      businesses: parsedBusinesses,
      answer: json['answer'],
    );
  }
}
