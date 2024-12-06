import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/search_model.dart';
import 'package:news_app/screen/article_view.dart';
import 'package:news_app/services/search.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class SearchScreen extends StatefulWidget {
  String query;
  SearchScreen({super.key, required this.query});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SearchModel> searchList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getSearchResults();
  }

  Future<void> getSearchResults() async {
    setState(() {
      _loading = true;
    });

    SearchNews newsService = SearchNews();
    await newsService.fetchSearchNews(widget.query);

    searchList = newsService.searchList;

    setState(() {
      searchList = newsService.searchList;
      _loading = false;
    });
  }

  void sortTrendingNewsByDate({bool ascending = true}) {
    setState(() {
      searchList.sort((a, b) {
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
      searchList.sort((a, b) {
        return ascending
            ? a.title!.compareTo(b.title!)
            : b.title!.compareTo(a.title!);
      });
    });
  }

  Future<void> _handleRefresh() async {
    await getSearchResults();
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
            Text(
              widget.query,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
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
            : searchList.isEmpty
                ? Center(
                    child: Text('No results found for "${widget.query}',
                        style: const TextStyle(fontSize: 18.0)),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          return ShowSearchQuery(
                              url: searchList[index].url ?? '',
                              imgUrl: searchList[index].urlToImage ?? '',
                              descriptionNews: searchList[index].description ??
                                  'No Description Available',
                              title: searchList[index].title ?? 'Untitled');
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

class ShowSearchQuery extends StatelessWidget {
  String imgUrl, title, descriptionNews, url;

  ShowSearchQuery(
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
