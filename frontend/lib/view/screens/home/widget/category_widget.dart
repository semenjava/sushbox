import 'package:flutter/material.dart';
import 'package:sushibox/data/model/response/category_model.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/view/screens/product/product_list_screen.dart'; // Предположим, у вас есть этот экран

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;

  CategoryWidget({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(
              categoryId: category.id,
              categoryName: category.name ?? '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Изображение
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${AppConstants.baseUrl}${AppConstants.imageFolder}category/${category.image}',
                height: 155, // Высота изображения
                width: double.infinity, // Ширина изображения
                fit: BoxFit.cover,
              ),
            ),
            // Текст поверх изображения
            Positioned(
              top: 0, // Размещаем текст вверху
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.black
                      .withOpacity(0.3), // Полупрозрачный черный фон для текста
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  category.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1), // Смещение тени
                        blurRadius: 4, // Радиус размытия тени
                        color: Colors.black
                            .withOpacity(0.5), // Полупрозрачная тень
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
