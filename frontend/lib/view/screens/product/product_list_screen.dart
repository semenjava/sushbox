import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushibox/provider/product_provider.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/utill/dimensions.dart';
import 'package:sushibox/utill/styles.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/view/screens/product/product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  final int? categoryId;
  final String categoryName;

  const ProductListScreen({
    required this.categoryId,
    required this.categoryName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false)
        .getProductList(categoryId.toString(), context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          categoryName,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: Dimensions.fontSizeLarge,
              ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.productList != null &&
              productProvider.productList!.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () => productProvider.refresh(context),
              displacement: 20,
              color: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                  childAspectRatio: 0.75, // Adjust as per your need
                ),
                itemCount: productProvider.productList!.length,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: productProvider.productList![index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    margin: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeSmall,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '${AppConstants.baseUrl}${productProvider.productList![index].image}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.fontSizeSmall),
                        Text(
                          productProvider.productList![index].name!,
                          style: rubikMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.fontSizeSmall),
                        Text(
                          '${getTranslated('price', context)}: ${productProvider.productList![index].price}',
                          style: rubikRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
