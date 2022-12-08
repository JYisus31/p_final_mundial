import 'dart:ffi';

class MxPlayersModel {
  Int? IdPlayer;
  String? ImgPlayer;

  MxPlayersModel({
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
