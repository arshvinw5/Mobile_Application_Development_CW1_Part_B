class ShowCategoryModel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? content;
  String? publishedAt;

  //contractor
  ShowCategoryModel(
      {this.author,
      this.description,
      this.title,
      this.url,
      this.urlToImage,
      this.content,
      this.publishedAt});
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
