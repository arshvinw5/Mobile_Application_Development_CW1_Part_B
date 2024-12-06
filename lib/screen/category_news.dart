import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/show_category.dart';
import 'package:news_app/screen/article_view.dart';
import 'package:news_app/services/show_category_data.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class CategoryNews extends StatefulWidget {
  //to show the category name on top of appbar
  String name;
  CategoryNews({super.key, required this.name});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];
  bool _loading = true;

  @override
  void initState() {
    //get the category list from getCat function
    getCategory();
    super.initState();
  }

  Future<void> getCategory() async {
    //made new object from news.dart
    ShowCategoryNews newsClass = ShowCategoryNews();
    //calling the fetch news function
    await newsClass.fetchCategoriesNews(widget.name.toLowerCase());
    //need to get lower letter otherwise API won't allow it
    //get the news list in news class
    categories = newsClass.categoryList;
    //making loading state

    setState(() {
      _loading = false;
    });
  }

  void sortTrendingNewsByDate({bool ascending = true}) {
    setState(() {
      categories.sort((a, b) {
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
      categories.sort((a, b) {
        return ascending
            ? a.title!.compareTo(b.title!)
            : b.title!.compareTo(a.title!);
      });
    });
  }

  Future<void> _handleRefresh() async {
    await getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const Text(
                  ' News',
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            sortIconButton(
              sortByDate: sortTrendingNewsByDate,
              sortByTitle: sortTrendingNewsByTitle,
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
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
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ShowCategory(
                          url: categories[index].url ?? '',
                          imgUrl: categories[index].urlToImage ?? '',
                          descriptionNews: categories[index].description ??
                              'No Description Available',
                          title: categories[index].title ?? 'Untitled');
                    }),
              ),
      ),
    );
  }
}

Widget sortIconButton({
  required Function sortByDate,
  required Function sortByTitle,
}) {
  return PopupMenuButton<String>(
    icon: const Icon(
      Icons.sort,
      color: Colors.black,
    ), // Icon for triggering
    onSelected: (String value) {
      // Perform actions based on the selected option
      if (value == "Sort by Date") {
        sortByDate(ascending: true);
      } else if (value == "Sort by Title (A-Z)") {
        sortByTitle(ascending: true);
      } else if (value == "Sort by Title (Z-A)") {
        sortByTitle(ascending: false);
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

class ShowCategory extends StatelessWidget {
  String imgUrl, title, descriptionNews, url;

  ShowCategory(
      {super.key,
      required this.imgUrl,
      required this.descriptionNews,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url))),
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Stack(
                        alignment: Alignment.center, // Center the loader
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
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    descriptionNews,
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 10.0,
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
