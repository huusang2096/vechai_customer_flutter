class Images {
  String path;
  Images(this.path);

}

class ImagesList {
  List<Images> _images;

  ImagesList() {
    this._images = [
      new Images("https://png.pngtree.com/thumb_back/fw800/background/20190223/ourmid/pngtree-fresh-garbage-classifieds-background-backgroundblue-skytrash-canlandfillgarbage-image_74708.jpg"),
      new Images("https://as2.ftcdn.net/jpg/01/92/29/05/500_F_192290515_c3bT5JgGx9zMDL6RX7p6KNhnLtInrbNK.jpg"),
      new Images("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSwKAYQC_5L-Yi1fX9t9f5B2-bEm1FvtdmhrGfIOnJimKoY8cxO"),
      new Images("https://cdn2.vectorstock.com/i/1000x1000/37/36/pile-of-trash-garbage-on-city-background-vector-20933736.jpg")
    ];
  }

  List<Images> get images => _images;

}
