import 'dart:ffi';

class FrPlayersModel {
  Int? IdPlayer;
  String? ImgPlayer;

  FrPlayersModel({
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
