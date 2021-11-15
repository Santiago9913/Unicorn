class Post {
  String content;
  String imgUrl;
  String owner;
  DateTime datePosted;

  Post({
    required this.content,
    this.imgUrl = "",
    required this.owner,
    required this.datePosted,
  });

  get getContent {
    return content;
  }

  get getImgUrl {
    return imgUrl;
  }

  get getOwner {
    return owner;
  }

  get getDatePosted {
    return datePosted;
  }

  void setContent(String nContent) {
    content = nContent;
  }

  void setImgUrl(String nUrl) {
    imgUrl = nUrl;
  }

  void setDatePosted(DateTime nDate) {
    datePosted = nDate;
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'owner': owner,
        'content': content,
        'imgUrl': imgUrl,
        'datePosted' : datePosted,
      };
}
