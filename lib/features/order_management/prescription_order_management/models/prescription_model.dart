class PrescriptionModel {
  int? id;
  int? userId;
  String? userName;
  String? imagePath;
  Null? fileName;
  String? status;
  String? notes;
  String? uploadedAt;
  List<VendorResponses>? vendorResponses;

  PrescriptionModel(
      {this.id,
      this.userId,
      this.userName,
      this.imagePath,
      this.fileName,
      this.status,
      this.notes,
      this.uploadedAt,
      this.vendorResponses});

  PrescriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    imagePath = json['image_path'];
    fileName = json['file_name'];
    status = json['status'];
    notes = json['notes'];
    uploadedAt = json['uploaded_at'];
    if (json['vendor_responses'] != null) {
      vendorResponses = <VendorResponses>[];
      json['vendor_responses'].forEach((v) {
        vendorResponses!.add(new VendorResponses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['image_path'] = this.imagePath;
    data['file_name'] = this.fileName;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['uploaded_at'] = this.uploadedAt;
    if (this.vendorResponses != null) {
      data['vendor_responses'] =
          this.vendorResponses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorResponses {
  int? id;
  int? vendorId;
  String? vendorName;
  String? vendorEmail;
  double? totalAmount;
  String? status;
  String? notes;
  String? respondedAt;
  List<Medicines>? medicines;

  VendorResponses(
      {this.id,
      this.vendorId,
      this.vendorName,
      this.vendorEmail,
      this.totalAmount,
      this.status,
      this.notes,
      this.respondedAt,
      this.medicines});

  VendorResponses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorEmail = json['vendor_email'];
    totalAmount = json['total_amount'];
    status = json['status'];
    notes = json['notes'];
    respondedAt = json['responded_at'];
    if (json['medicines'] != null) {
      medicines = <Medicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new Medicines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['vendor_name'] = this.vendorName;
    data['vendor_email'] = this.vendorEmail;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['responded_at'] = this.respondedAt;
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicines {
  int? id;
  int? itemId;
  String? name;
  String? brand;
  String? dosage;
  int? quantity;
  double? price;
  String? notes;
  bool? isAvailable;
  String? imagePath;

  Medicines(
      {this.id,
      this.itemId,
      this.name,
      this.brand,
      this.dosage,
      this.quantity,
      this.price,
      this.notes,
      this.isAvailable,
      this.imagePath});

  Medicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    name = json['name'];
    brand = json['brand'];
    dosage = json['dosage'];
    quantity = json['quantity'];
    price = json['price'];
    notes = json['notes'];
    isAvailable = json['is_available'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['dosage'] = this.dosage;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['notes'] = this.notes;
    data['is_available'] = this.isAvailable;
    data['image_path'] = this.imagePath;
    return data;
  }
}
