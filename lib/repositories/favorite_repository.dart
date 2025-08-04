// lib/repositories/favorite_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteRepository {
  static const String _favoriteKey = 'favorite_artwork_ids';
  
  // Singleton pattern
  static final FavoriteRepository _instance = FavoriteRepository._internal();
  factory FavoriteRepository() => _instance;
  FavoriteRepository._internal();

  // Lấy danh sách ID yêu thích
  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoriteJson = prefs.getString(_favoriteKey);
    if (favoriteJson == null) {
      return [];
    }
    
    List<dynamic> decodedList = jsonDecode(favoriteJson);
    return decodedList.map((item) => item.toString()).toList();
  }

  // Lưu danh sách ID yêu thích
  Future<bool> saveFavoriteIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_favoriteKey, jsonEncode(ids));
  }

  // Thêm ID vào danh sách yêu thích
  Future<bool> addToFavorites(String id) async {
    List<String> currentIds = await getFavoriteIds();
    if (!currentIds.contains(id)) {
      currentIds.add(id);
      return await saveFavoriteIds(currentIds);
    }
    return true;
  }

  // Xóa ID khỏi danh sách yêu thích
  Future<bool> removeFromFavorites(String id) async {
    List<String> currentIds = await getFavoriteIds();
    if (currentIds.contains(id)) {
      currentIds.remove(id);
      return await saveFavoriteIds(currentIds);
    }
    return true;
  }

  // Kiểm tra ID có trong danh sách yêu thích không
  Future<bool> isFavorite(String id) async {
    List<String> currentIds = await getFavoriteIds();
    return currentIds.contains(id);
  }

  // Toggle trạng thái yêu thích
  Future<bool> toggleFavorite(String id) async {
    if (await isFavorite(id)) {
      return await removeFromFavorites(id);
    } else {
      return await addToFavorites(id);
    }
  }
}
