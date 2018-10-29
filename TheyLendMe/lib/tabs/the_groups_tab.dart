import 'package:flutter/material.dart';
import 'package:TheyLendMe/pages/user_page.dart';

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
    return new GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return UserPage(group.img);
          }
        );
      },
      child: ListTile(
        leading: new CircleAvatar(
            child: new Text(group.title[0]), //just the initial letter in a circle
            backgroundColor: Colors.yellow
          ),
        title: Text(group.title),
        subtitle: new Text(group.subtitle)
      )
    );
  }
}

class Group {
  Group(
    this.title,
    this.subtitle,
    this.img
  );

  final String title;
  final String subtitle;
  final Image img;
}

final List<Group> groups = <Group>[
  Group('Asociación ASOC','una asociación',Image.network('https://http.cat/400')),
  Group('Grupo GRP','un grupo',Image.network('https://http.cat/401')),
  Group('Equipo C.D.EQUIPO','un equipo',Image.network('https://http.cat/402')),
  Group('Organización ORGANIZ','una organización',Image.network('https://http.cat/403')),
  Group('Clase CLAS1','una clase',Image.network('https://http.cat/404')),
];