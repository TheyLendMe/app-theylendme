import 'package:flutter/material.dart';

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
        body: ListView.builder( //ListView de ejemplo:
          itemBuilder: (BuildContext context, int index) => GroupItem(groups[index]),
          itemCount: groups.length
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
    return new ListTile(
      leading: new CircleAvatar(
          child: new Text(group.title[0]), //just the initial letter in a circle
          backgroundColor: Colors.yellow
        ),
      title: Text(group.title),
      subtitle: new Text(group.subtitle)
    );
  }
}

class Group {
  Group(
    this.title,
    this.subtitle,
    //[this.children = const <Group>[]]
  );

  final String title;
  final String subtitle;
  //final List<Group> children; //TODO: expandable list maybe?
}

final List<Group> groups = <Group>[
  Group('Asociación ASOC','una asociación'),
  Group('Grupo GRP','un grupo'),
  Group('Equipo C.D.EQUIPO','un equipo'),
  Group('Organización ORGANIZ','una organización'),
  Group('Clase CLAS1','una clase'),
];