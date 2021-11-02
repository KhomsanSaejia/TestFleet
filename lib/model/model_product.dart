class ProductModel {
  int? id;
  String? productId;
  String? productName;
  String? productDetail;

  ProductModel({this.id, this.productId, this.productName, this.productDetail});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productDetail = json['product_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_detail'] = productDetail;
    return data;
  }
}
