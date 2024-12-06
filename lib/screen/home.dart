import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/screen/all_view.dart';
import 'package:news_app/screen/article_view.dart';
import 'package:news_app/screen/category_news.dart';
import 'package:news_app/screen/search_screen.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //making list to save item from getCategories function
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];

  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;

  int activeIndex = 0;

  @override
  void initState() {
    //get the category list from getCat function
    categories = getCategories();
    getBreakingNews();
    getNews();
    super.initState();
  }

  Future<void> _handleRefresh() async {
    await getBreakingNews();
    await getNews();
  }

  //get function
  Future<void> getNews() async {
    //made new object from news.dart
    News newsClass = News();
    //calling the fetch news function
    await newsClass.fetchNews();
    //get the news list in news class
    articles = newsClass.news;
    //making loading state

    setState(() {
      _loading = false;
    });
  }

  //function to fetch breaking news to slider
  Future<void> getBreakingNews() async {
    BreakingNews newBreakingNewsClass = BreakingNews();
    await newBreakingNewsClass.fetchBreakingNews();
    sliders = newBreakingNewsClass.breakingNews;
    setState(() {
      _loading = false;
    });
  }

  void sortTrendingNewsByDate({bool ascending = true}) {
    setState(() {
      articles.sort((a, b) {
        DateTime dateA =
            DateTime.parse(a.publishedAt ?? DateTime.now().toString());
        DateTime dateB =
            DateTime.parse(b.publishedAt ?? DateTime.now().toString());
        return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      });
    });
  }

  void sortTrendingNewsByTitle({bool ascending = true}) {
    setState(() {
      articles.sort((a, b) {
        return ascending
            ? a.title!.compareTo(b.title!)
            : b.title!.compareTo(a.title!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'News',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              'App',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Colors.grey.shade300,
        backgroundColor: Colors.red,
        animSpeedFactor: 2.0,
        showChildOpacityTransition: false,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 5,
              ))
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                            //to run that search function
                            controller: _searchController,
                            onSubmitted: (query) {
                              if (query.trim().isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchScreen(query: query.trim())));
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Search News",
                                hintStyle: const TextStyle(color: Colors.grey),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)))),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        height: 70,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return CategoryTile(
                                image: categories[index].image,
                                categoryName: categories[index].categoryName,
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Breaking News...',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllNewsView(news: "Breaking"))),
                              child: Text(
                                'View all',
                                style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      CarouselSlider.builder(
                          itemCount: sliders.length,
                          itemBuilder: (context, index, realIndex) {
                            String? resImg = sliders[index].urlToImage;
                            String? resName = sliders[index].title;
                            String? resNewsUrl = sliders[index].url;
                            //passing arguments to build images
                            return buildImage(
                                resImg!, index, resName!, resNewsUrl!);
                          },
                          options: CarouselOptions(
                              height: 300,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activeIndex = index;
                                });
                              })),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Center(child: buildIndicator()),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trending News...',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AllNewsView(news: "Trending"))),
                                  child: Text(
                                    'View all',
                                    style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                ),
                                sortIconButton(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              return BlogTile(
                                  url: articles[index].url!,
                                  imgUrl: articles[index].urlToImage!,
                                  descriptionNews: articles[index].description!,
                                  title: articles[index].title!);
                            }),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget sortIconButton() {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.sort,
        color: Colors.black,
      ), // Icon for triggering
      onSelected: (String value) {
        // Perform actions based on the selected option
        if (value == "Sort by Date") {
          sortTrendingNewsByDate(ascending: true);
        } else if (value == "Sort by Title (A-Z)") {
          sortTrendingNewsByTitle(ascending: true);
        } else if (value == "Sort by Title (Z-A)") {
          sortTrendingNewsByTitle(ascending: false);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: "Sort by Date",
            child: Text("Sort by Date"),
          ),
          const PopupMenuItem(
            value: "Sort by Title (A-Z)",
            child: Text("Sort by Title (A-Z)"),
          ),
          const PopupMenuItem(
            value: "Sort by Title (Z-A)",
            child: Text("Sort by Title (Z-A)"),
          ),
        ];
      },
    );
  }

  Widget buildImage(String image, int index, String name, String urlNews) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleView(blogUrl: urlNews)));
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          color: Colors.grey[
                              200], // Optional placeholder background color
                        ),
                        const SizedBox(
                          width: 30, // Smaller size for the loader
                          height: 30,
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 5, // Adjust thickness
                          ),
                        ),
                      ],
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                //to provide text in container
                Container(
                  height: 300,
                  padding: const EdgeInsets.only(left: 20.0),
                  margin: const EdgeInsets.only(top: 210.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: sliders.length,
        effect: const WormEffect(
            dotColor: Colors.black,
            activeDotColor: Colors.red,
            dotWidth: 10,
            dotHeight: 10),
      );
}

//made tile widget
class CategoryTile extends StatelessWidget {
  final String? image, categoryName;
  const CategoryTile({this.image, this.categoryName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(name: categoryName!)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  image ?? '',
                  width: 120,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: 120,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    categoryName ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  String imgUrl, title, descriptionNews, url;

  BlogTile(
      {super.key,
      required this.imgUrl,
      required this.descriptionNews,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Text(
                          descriptionNews,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




      // bottomNavigationBar: SafeArea(
      //     child: Container(
      //         decoration: const BoxDecoration(color: Colors.transparent),
      //         padding: const EdgeInsets.all(8),
      //         child: Container(
      //           padding: const EdgeInsets.all(12),
      //           margin: const EdgeInsets.symmetric(horizontal: 90.0),
      //           decoration: const BoxDecoration(
      //               color: Colors.black,
      //               borderRadius: BorderRadius.all(Radius.circular(10))),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               GestureDetector(
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: const SizedBox(
      //                   height: 36,
      //                   width: 36,
      //                   child: Icon(
      //                     Icons.home,
      //                     color: Colors.white,
      //                     size: 36,
      //                   ),
      //                 ),
      //               ),
      //               GestureDetector(
      //                 onTap: () {},
      //                 child: const SizedBox(
      //                   height: 36,
      //                   width: 36,
      //                   child: Icon(
      //                     Icons.favorite,
      //                     color: Colors.white,
      //                     size: 36,
      //                   ),
      //                 ),
      //               ),
      //               GestureDetector(
      //                 onTap: () {},
      //                 child: const SizedBox(
      //                   height: 36,
      //                   width: 36,
      //                   child: Icon(
      //                     Icons.settings,
      //                     color: Colors.white,
      //                     size: 36,
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ))),
