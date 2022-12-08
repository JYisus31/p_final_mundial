import 'dart:ffi';

class TeamsModel {
  String? Group;
  Int? IdTeam;
  String? TeamLogo;
  String? TeamName;
  String? TeamShort;

  TeamsModel(
    {this.Group,
    this.IdTeam,
    this.TeamLogo,
    this.TeamName,
    this.TeamShort}
  );

Map<String, dynamic> toMap(){
  return{
  'Group' : this.Group,
  'IdTeam' : this.IdTeam,
  'TeamLogo' : this.TeamLogo,
  'TeamName' : this.TeamName,
  'TeamShort' : this.TeamShort,
  };
}
}