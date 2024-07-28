import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/view/screens/home/widget/category_widget.dart';
import 'package:sushibox/provider/banner_provider.dart';
import 'package:sushibox/provider/home_provider.dart';
import 'package:sushibox/provider/products_latest_provider.dart';
import 'package:sushibox/utill/dimensions.dart';
import 'package:sushibox/view/screens/language/choose_language_screen.dart';
import 'package:sushibox/view/screens/search/search_screen.dart';
import 'package:sushibox/view/screens/cart/cart_screen.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/view/screens/product/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false).getCategoryList(context);
    Provider.of<BannerProvider>(context, listen: false).getBannerList(context);
    Provider.of<ProductsLatestProvider>(context, listen: false)
        .getProductsLatest(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leadingWidth: 0,
        actions: [
          // Кнопка смены языка
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'language':
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        const ChooseLanguageScreen(fromHomeScreen: true),
                  ));
                  break;
              }
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'language',
                child: Row(
                  children: [
                    Icon(Icons.language,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    Text(
                      getTranslated('change_language', context)!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Иконка корзины
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CartScreen(),
              ));
            },
            icon: SvgPicture.network(
              '${AppConstants.baseUrl}/assets/img/cart.svg', // URL вашей иконки корзины в формате SVG
              width: 24,
              height: 24,
            ),
          ),
        ],
        leading: const SizedBox.shrink(),
        // Замена заголовка на логотип
        title: Image.network(
          '${AppConstants.baseUrl}/assets/img/logo.png', // URL вашего логотипа
          width: 120, // Задайте ширину и высоту логотипа по вашему желанию
          fit: BoxFit.contain, // Подгонять логотип под размер контейнера
        ),
      ),
      body: Stack(
        children: [
          // Background image with dark overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  '${AppConstants.baseUrl}/assets/img/home.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.srcOver,
                ),
              ),
            ),
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => _refreshData(context),
              child: Consumer3<BannerProvider, HomeProvider,
                  ProductsLatestProvider>(
                builder: (context, bannerProvider, homeProvider,
                    productsLatestProvider, child) {
                  return ListView(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    children: [
                      // Search field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SearchScreen(),
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.3), // Search field background color
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.network(
                                  '${AppConstants.baseUrl}/assets/img/search.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 16),
                                Text(
                                  getTranslated('search', context)!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Categories
                      homeProvider.categoryList != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  height: 200, // Fixed height
                                  child: PageView.builder(
                                    itemCount:
                                        (homeProvider.categoryList!.length / 8)
                                            .ceil(),
                                    itemBuilder: (context, pageIndex) {
                                      final startIndex = pageIndex * 8;
                                      final endIndex = (startIndex + 8) >
                                              homeProvider.categoryList!.length
                                          ? homeProvider.categoryList!.length
                                          : startIndex + 8;
                                      final pageCategories = homeProvider
                                          .categoryList!
                                          .sublist(startIndex, endIndex);

                                      return GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 1,
                                          crossAxisSpacing:
                                              Dimensions.paddingSizeSmall,
                                          mainAxisSpacing:
                                              Dimensions.paddingSizeSmall,
                                        ),
                                        itemCount: pageCategories.length,
                                        itemBuilder: (context, index) {
                                          return CategoryWidget(
                                            category: pageCategories[index],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 20),
                      // Banners
                      bannerProvider.bannerList != null &&
                              bannerProvider.bannerList!.isNotEmpty
                          ? Container(
                              height: 200,
                              child: PageView.builder(
                                itemCount: bannerProvider.bannerList!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.network(
                                      '${AppConstants.baseUrl}${AppConstants.imageFolder}banner/${bannerProvider.bannerList![index].image!}',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 20),
                      // Latest products slider
                      productsLatestProvider.productsLatest != null &&
                              productsLatestProvider.productsLatest!.isNotEmpty
                          ? Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productsLatestProvider
                                    .productsLatest!.length,
                                itemBuilder: (context, index) {
                                  final product = productsLatestProvider
                                      .productsLatest![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 160, // Product container width
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 9, 17, 26),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(8)),
                                              child: Image.network(
                                                '${AppConstants.baseUrl}${product.image}',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name!,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '${product.price} \$',
                                                  style: TextStyle(
                                                    color: Color(Color.fromRGBO(
                                                            198, 168, 125, 1)
                                                        .value),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context);
    await Provider.of<HomeProvider>(context, listen: false)
        .getCategoryList(context);
    await Provider.of<ProductsLatestProvider>(context, listen: false)
        .getProductsLatest(context);
  }
}
