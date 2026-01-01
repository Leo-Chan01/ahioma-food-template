import 'package:ahioma_food_template/features/storefront/data/models/storefront_product_model.dart';

/// Mock food data for development and testing.
/// This can be easily swapped with real API data by changing the data source
/// in the home screen without any UI changes.
class MockFoodData {
  static const bool useMockData = true; // Set to false to use real API

  static List<StorefrontProductModel> getDiscountProducts() {
    return [
      const StorefrontProductModel(
        id: 'mock-1',
        name: 'Mixed Salad Bonbon',
        slug: 'mixed-salad-bonbon',
        price: 6.00,
        description: 'Fresh mixed salad with grilled chicken and vegetables',
        images: [
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        ],
        rating: 4.8,
        reviewCount: 120,
        soldCount: 1200,
        category: 'Salads',
        isFeatured: true,
        isActive: true,
        stock: 50,
      ),
      const StorefrontProductModel(
        id: 'mock-2',
        name: 'Vegetarian Menu',
        slug: 'vegetarian-menu',
        price: 5.50,
        description: 'Healthy vegetarian bowl with fresh greens',
        images: [
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        ],
        rating: 4.7,
        reviewCount: 900,
        soldCount: 850,
        category: 'Vegetarian',
        isFeatured: true,
        isActive: true,
        stock: 30,
      ),
      const StorefrontProductModel(
        id: 'mock-3',
        name: 'Grilled Chicken Bowl',
        slug: 'grilled-chicken-bowl',
        price: 7.50,
        description: 'Tender grilled chicken with rice and vegetables',
        images: [
          'https://images.unsplash.com/photo-1546069901-eacef0df6022?w=400',
        ],
        rating: 4.9,
        reviewCount: 450,
        soldCount: 680,
        category: 'Chicken',
        isFeatured: true,
        isActive: true,
        stock: 40,
      ),
      const StorefrontProductModel(
        id: 'mock-4',
        name: 'Seafood Pasta',
        slug: 'seafood-pasta',
        price: 8.00,
        description: 'Delicious pasta with fresh seafood',
        images: [
          'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400',
        ],
        rating: 4.6,
        reviewCount: 320,
        soldCount: 540,
        category: 'Pasta',
        isFeatured: true,
        isActive: true,
        stock: 25,
      ),
    ];
  }

  static List<StorefrontProductModel> getRecommendedProducts() {
    return [
      const StorefrontProductModel(
        id: 'mock-5',
        name: 'Vegetarian Noodles',
        slug: 'vegetarian-noodles',
        price: 2.00,
        description: 'Asian-style vegetarian noodles with fresh vegetables',
        images: [
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
        ],
        rating: 4.9,
        reviewCount: 2300,
        soldCount: 3400,
        category: 'Noodles',
        isActive: true,
        stock: 100,
      ),
      const StorefrontProductModel(
        id: 'mock-6',
        name: 'Pizza Hut - Lumintu',
        slug: 'pizza-hut-lumintu',
        price: 1.50,
        description: 'Classic pizza with cheese and pepperoni',
        images: [
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
        ],
        rating: 4.5,
        reviewCount: 1900,
        soldCount: 2800,
        category: 'Pizza',
        isActive: true,
        stock: 80,
      ),
      const StorefrontProductModel(
        id: 'mock-7',
        name: 'Mozarella Cheese Burger',
        slug: 'mozarella-cheese-burger',
        price: 2.50,
        description: 'Juicy burger with mozarella cheese',
        images: [
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        ],
        rating: 4.6,
        reviewCount: 1500,
        soldCount: 2100,
        category: 'Burger',
        isActive: true,
        stock: 60,
      ),
      const StorefrontProductModel(
        id: 'mock-8',
        name: 'Fruit Salad - Kumpa',
        slug: 'fruit-salad-kumpa',
        price: 2.00,
        description: 'Fresh fruit salad with seasonal fruits',
        images: [
          'https://images.unsplash.com/photo-1564093497595-593b96d80180?w=400',
        ],
        rating: 4.7,
        reviewCount: 1700,
        soldCount: 1900,
        category: 'Dessert',
        isActive: true,
        stock: 45,
      ),
      const StorefrontProductModel(
        id: 'mock-9',
        name: 'Chicken Teriyaki',
        slug: 'chicken-teriyaki',
        price: 6.50,
        description: 'Grilled chicken with teriyaki sauce and rice',
        images: [
          'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
        ],
        rating: 4.8,
        reviewCount: 980,
        soldCount: 1450,
        category: 'Chicken',
        isActive: true,
        stock: 35,
      ),
      const StorefrontProductModel(
        id: 'mock-10',
        name: 'Beef Tacos',
        slug: 'beef-tacos',
        price: 5.00,
        description: 'Mexican-style beef tacos with fresh toppings',
        images: [
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400',
        ],
        rating: 4.7,
        reviewCount: 750,
        soldCount: 1200,
        category: 'Mexican',
        isActive: true,
        stock: 50,
      ),
    ];
  }

  static List<StorefrontProductModel> getAllProducts() {
    return [...getDiscountProducts(), ...getRecommendedProducts()];
  }
}
