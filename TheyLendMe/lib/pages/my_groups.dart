import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_group.dart';
import 'package:TheyLendMe/pages/my_group_details.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'group_settings_panel.dart';
import 'join_group.dart';
import 'package:fab_dialer/fab_dialer.dart';


class MyGroupsPage extends StatefulWidget {
  @override
  _MyGroupsPageState createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {

  @override
  Widget build(BuildContext context) {
  
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.noText(
        
        new Icon(Icons.add),
        Colors.orange,
        4.0,
        "Crea un grupo",
        (){
          showDialog(
            context: this.context,
            builder: (BuildContext context){
              return CreateGroup();
            },);
        },),
      new FabMiniMenuItem.noText(
        new Icon(Icons.group_add), 
        Colors.orange, 
        4.0, 
        "Unirse a un grupo", 
        (){
          showDialog(
            context: this.context,
            builder: (BuildContext context){
              return JoinGroup();
            }
          );
        },)
    ];
    return Scaffold(
      appBar: AppBar(
          title: const Text('Mis Grupos'),
          //TODO: searchBar
        ),
      body: FutureBuilder<List<Group>>(
        future: UserSingleton().user.getGroupsImMember(),
        builder: (context, snapshot) {
          return (snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) => GroupItem(
                  snapshot.data[index], 
                  snapshot.data[index].imAdmin
                ),
                itemCount: snapshot.data.length
              )
            : Center(child: CircularProgressIndicator()));
        }
      ),
      // Fab menu, crear grupo y unirse a grupo
      floatingActionButton: new FabDialer(_fabMiniMenuItemList, Colors.orange, new Icon(Icons.group),new Icon(Icons.group),180,true),
    );
  }
}


// Displays one Group.
class GroupItem extends StatelessWidget {

  const GroupItem(this.group, this.admin);
  final Group group;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return GroupDetails(group);
          }
        );
      },
      child: ListTile(
        leading: CircleAvatar(
            child: (group.img!=null ? Text('') : Text(getFirstCharacter(group.name), style: TextStyle(color: Colors.black))),
            backgroundImage: (group.img!=null ? NetworkImage(group.img) : null),
            backgroundColor: Theme.of(context).accentColor
          ),
        title: Text(group.name),
        subtitle: (group.info!=null
          ? Text(group.info)
          : Text('')),
        trailing: (admin 
          ? MaterialButton(
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) => new GroupSettingsPanel(group)
              ));
            },
            child: new Text('Administrar'),
            color: Colors.red,)
          : null
        ),
      ),
    );
  }
}

/*
class GroupAdminItem extends StatelessWidget {

  const GroupAdminItem(this.group);
  final Group group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return GroupDetails(group);
          }
        );
      },
      child: ListTile(
        leading: CircleAvatar(
            child: (group.img!=null ? Text('') : Text(getFirstCharacter(group.name), style: TextStyle(color: Colors.black))),
            backgroundImage: (group.img!=null ? NetworkImage(group.img) : null),
            backgroundColor: Theme.of(context).accentColor
          ),
        title: Text(group.name),
        subtitle: (group.info!=null
          ? Text(group.info)
          : Text('')),
        trailing: MaterialButton(
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) => new GroupSettingsPanel(group)
            ));
          },
          child: new Text('Administrar'),
          color: Colors.red,
          
        ),
      )

    );
  }
}*/

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}

