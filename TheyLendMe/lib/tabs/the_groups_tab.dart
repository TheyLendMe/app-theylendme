import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/group_details.dart';
import 'package:TheyLendMe/Objects/entity.dart';

// Pestaña GRUPOS
class TheGroupsTab extends StatefulWidget {
    @override
    _TheGroupsTabState createState() => _TheGroupsTabState();
}

// CONTENIDO de la pestaña GRUPOS
class _TheGroupsTabState extends State<TheGroupsTab> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Widget groupList;


  Future<Null> _refresh() {
    return Group.getGroups().then((_groups) {
      groupList = ListView.builder(
          itemBuilder: (BuildContext context, int index) => GroupItem(_groups[index]),
          itemCount: _groups.length
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator( //example: https://github.com/sharmadhiraj/flutter_examples/blob/master/lib/pages/refresh_indicator.dart
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: FutureBuilder<List<Group>>(
          future: Group.getGroups(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(groupList == null){
                groupList = ListView.builder(
                    itemBuilder: (BuildContext context, int index) => GroupItem(snapshot.data[index]),
                    itemCount: snapshot.data.length
                );
              }
              return groupList;
            } else { return Center(child: CircularProgressIndicator()); }
        })
      )
    );
  }

  
  
}

// Displays one Group.
class GroupItem extends StatelessWidget {

  //(watching https://youtu.be/iflV0D0d1zQ)

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
            child: (group.img!=null ? Text('') : Text(getFirstCharacter(group.name))),
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