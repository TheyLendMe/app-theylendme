import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/group_details.dart';
import 'package:TheyLendMe/Objects/entity.dart';

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
      body: ListView.builder( //ListView de ejemplo:
        itemBuilder: (BuildContext context, int index) => GroupItem(groups[index]),
        itemCount: groups.length
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
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return GroupDetails(group);
          }
        );
      },
      child: Container(
        padding: new EdgeInsets.only(left: 8.0, top: 15.0),
        child: ListTile(
          leading: new CircleAvatar(
              child: new Text(group.name[0]), //just the initial letter in a circle
              backgroundColor: Colors.yellow
            ),
          title: new Container(
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(group.name),
              ]
            )
          )
        ) //end ListTile
      ) //end Container
    );
  }
}

final List<Group> groups = <Group>[
  Group(1,'MiGrupo1', img: 'https://static.simpsonswiki.com/images/2/24/Simpson_Family.png',
    info: 'grupo1', tfno: '34606991934', email: 'sofia@adolfodominguez.com'),
  Group(2,'MiGrupo2', img: 'https://static.simpsonswiki.com/images/1/1b/Flanders_Family.png',
    info: 'grupo2', tfno: '34606991934', email: 'sofia@adolfodominguez.com')
];
