import 'dart:ffi';

class ArgPlayersModel {
  Int? IdPlayer;
  String? ImgPlayer;

  ArgPlayersModel({
    this.IdPlayer,
    this.ImgPlayer,
  });

  Map<String, dynamic> toMap() {
    return {
      'IdPlayer': this.IdPlayer,
      'ImgPlayer': this.ImgPlayer,
    };
  }
}
