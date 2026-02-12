import 'package:cloud_firestore/cloud_firestore.dart';
class ServiceModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageProfileUrl;
  final String imageUrl;
  final String category;
  final String subCategory;
  final String location;

  final double rating;
  final int reviewsCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String createdBy;
  final String updatedBy;

  ServiceModel({required this.id, required this.title, required this.description, required this.price, required this.imageUrl, required this.category, required this.subCategory, required this.location, required this.rating, required this.reviewsCount, required this.createdAt, required this.updatedAt, required this.createdBy, required this.updatedBy , required this.imageProfileUrl});

  factory ServiceModel.fromMap(Map<String, dynamic> data , String documentId){
    return ServiceModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      imageProfileUrl: data['imageProfileUrl'] ?? '',
      category: data['category'] ?? '',
      subCategory: data['subCategory'] ?? '',
      location: data['location'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewsCount: data['reviewsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
    );
  }
  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'price': price, 
      'imageUrl': imageUrl,
      'imageProfileUrl': imageProfileUrl,
      'category': category,
      'subCategory': subCategory,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy, 
      'location': location,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }

    ServiceModel copyWith({
      String? title,
      String? description,
      double? price,
      String? imageUrl,
      String? imageProfileUrl,
      String? category,
      String? subCategory,
      String? location,
      double? rating,
      int? reviewsCount,
      DateTime? updatedAt,
      String? updatedBy,
    }) {
      return ServiceModel(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        imageProfileUrl: imageProfileUrl ?? this.imageProfileUrl,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        location: location ?? this.location,
        rating: rating ?? this.rating,
        reviewsCount: reviewsCount ?? this.reviewsCount,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
      );
    }
}