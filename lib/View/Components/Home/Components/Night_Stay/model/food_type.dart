enum FoodType { breakfast, lunch, dinner }

extension FoodTypeName on FoodType {
  String get foodTypeName {
    switch (this) {
      case FoodType.dinner:
        return "Dinner";
      case FoodType.breakfast:
        return "Breakfast";
      case FoodType.lunch:
        return "Lunch";
    }
  }
}
