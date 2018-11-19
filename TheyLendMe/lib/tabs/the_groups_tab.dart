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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Group>>(
        future: Group.getGroups(),
        builder: (context, snapshot) {
          return (snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) => GroupItem(snapshot.data[index]),
                itemCount: snapshot.data.length
              )
            : Center(child: CircularProgressIndicator()));
        }
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
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return GroupDetails(group);
          }
        );
      },
      child: ListTile(
        leading: new CircleAvatar(
            child: new Text(group.name[0]), //just the initial letter in a circle
            backgroundColor: Colors.yellow
          ),
        title: Text(group.name),
        subtitle: (group.info!=null
          ? Text(group.info)
          : Text(''))
      )
    );
  }
}

/*final List<Group> groups = <Group>[
  Group(1,'Asociación ASOC', info: 'una asociación', img: 'https://static.simpsonswiki.com/images/2/24/Simpson_Family.png', tfno: '34606991934', email: 'sofia@adolfodominguez.com'),
  Group(2,'Grupo GRP', info: 'un grupo', img: 'https://static.simpsonswiki.com/images/1/1b/Flanders_Family.png', email: 'sofia@adolfodominguez.com'),
  Group(3,'Equipo C.D: .EQUIPO', info:'un equipo', img: 'https://static.simpsonswiki.com/images/2/24/Simpson_Family.png', tfno: '34606991934', email: 'sofia@adolfodominguez.com'),
  Group(4,'Organización ORGANIZ', info: 'una organización', img: 'https://static.simpsonswiki.com/images/1/1b/Flanders_Family.png', email: 'sofia@adolfodominguez.com'),
  Group(5,'Clase CLAS1', info: 'una clase', img: 'https://static.simpsonswiki.com/images/2/24/Simpson_Family.png', tfno: '34606991934', email: 'sofia@adolfodominguez.com'),
];*/
