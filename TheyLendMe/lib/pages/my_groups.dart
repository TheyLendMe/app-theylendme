import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/create_group.dart';
import 'package:TheyLendMe/pages/group_details.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class MyGroupsPage extends StatefulWidget {
  @override
  _MyGroupsPageState createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {

  @override
  Widget build(BuildContext context) {

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
                itemBuilder: (BuildContext context, int index) => GroupItem(snapshot.data[index]),
                itemCount: snapshot.data.length
              )
            : Center(child: CircularProgressIndicator()));
        }
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, color: Theme.of(context).primaryColor),
        onPressed: (){
          showDialog(
            context: this.context,
            builder: (BuildContext context){
              return CreateGroup();
            }
          );
        },
      )
    );
  }
}

// Displays one Group.
class GroupItem extends StatelessWidget {

  const GroupItem(this.group);
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
          : Text(''))
      )
    );
  }
}

String getFirstCharacter(String getFirstCharacter){
  //Un poco feo [\u{1F600}-\U+E007F]
  var regex = '[\u{1F600}\\-\\u{E007F}]';
  String textWithoutEmojis = getFirstCharacter.replaceAll(new RegExp(regex), '');
  return textWithoutEmojis[0];}