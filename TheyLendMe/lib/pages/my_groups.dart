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
<<<<<<< HEAD
              child: ((group.img !=null)
              ? Image.network(group.img)
              : Image.asset('images/def_group_pic.png')), //just the initial letter in a circle
=======
              child: new Text(group.name[0]), //just the initial letter in a circle
              backgroundColor: Theme.of(context).accentColor
>>>>>>> 9f3173e70780f7022b0ae54e44e16972e54d1ad8
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
