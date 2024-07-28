import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushibox/provider/home_provider.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/utill/dimensions.dart';
import 'package:sushibox/view/screens/product/product_list_screen.dart';
import 'package:sushibox/utill/app_constants.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false).getCategoryList(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated('category_list', context)!),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.categoryList != null &&
              homeProvider.categoryList!.isNotEmpty) {
            return ListView.separated(
              itemCount: homeProvider.categoryList!.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final category = homeProvider.categoryList![index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  leading: category.image != null
                      ? Image.network(
                          '${AppConstants.baseUrl}${AppConstants.imageFolder}category/${category.image}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.image),
                        ),
                  title: Text(category.name ?? ''),
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
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
