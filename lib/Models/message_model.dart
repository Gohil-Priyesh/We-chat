class message_model {
  String? msg;
  String? read;
  String? told;
  String? fromid;
  String? sent;
  Type? type;

  message_model(
      {this.msg, this.read, this.told, this.type, this.fromid, this.sent});

  message_model.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromid = json['fromid'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['told'] = this.told;
    data['type'] = this.type!.name;
    data['fromid'] = this.fromid;
    data['sent'] = this.sent;
    return data;
  }
}
/// we have created an enum named Type which is use in the declaration of class field type above
/// which is of a Tpye? type.
enum Type { text, image }
