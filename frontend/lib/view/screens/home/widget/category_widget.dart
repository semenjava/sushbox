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
          color: Colors.transparent, // Установка прозрачного фона
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 7, 33, 66).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Смещение тени
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (category.image != null)
                Image.network(
                  '${AppConstants.baseUrl}${AppConstants.imageFolder}category/${category.image}',
                  height: 130, // Change height here
                  width: 130, // Change width here
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 0), // Add space between image and text
              Flexible(
                child: Text(
                  category.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
