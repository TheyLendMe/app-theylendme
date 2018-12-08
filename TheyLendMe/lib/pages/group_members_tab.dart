import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupMembersTab extends StatefulWidget {

  final Group _group;
  GroupMembersTab(this._group);

  @override
  _GroupMembersTabState createState() => _GroupMembersTabState();
}

class _GroupMembersTabState extends State<GroupMembersTab> {

  @override
  Widget build (BuildContext context){

    return FutureBuilder<List<User>>(
      future: widget._group.getGroupMembers(),//FIXME: aqui hago la peticion
      builder: (context,snapshot) {
        return (snapshot.hasData
        ? ListView.builder(
          itemBuilder: (BuildContext context, int index) => MemberItem(snapshot.data[index],widget._group),
          itemCount: snapshot.data.length,)
        : Center(child: CircularProgressIndicator()));
      }
    );

    
  }
}

class MemberItem extends StatelessWidget {

  final User member;
  final Group _group;
  const MemberItem(this.member,this._group);

  void choiceAction(String choice){
    if(choice == Constants._admin){
      _group.addAdmin(member); //FIXME: idmember = 0
    } else if(choice == Constants._kick){
      _group.delUser(u: member);
    }
  }
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      /*onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return ObjectDetails(member);
          }
        );
      },*/

      child: Container(
        padding: new EdgeInsets.only(left: 8.0, top: 15.0),
        child: ListTile(
          leading: Container(
            child: (member.img!=null
              ? Image.network(member.img, width: 30)
              : Image.asset('images/def_obj_pic.png', width: 30)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0)
            )
          ),
          title: Text(member.name),
          trailing: PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice){
                return new PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: choiceAction,
            icon: new Icon(Icons.more_horiz),
          ) /*IconButton(
            icon: new Icon(Icons.more_horiz),
            onPressed: () {
              Fluttertoast.showToast(msg:'pudrete',toastLength: Toast.LENGTH_LONG);
              showMenu<String>(
                initialValue: ,
                context: context,
                items: Constants.choices.map((String choice){
                    return new PopupMenuItem<String>(
                      value: choice,
                      child: new Text(choice),
                    );}).toList(),
              );}
              new PopupMenuButton<String>(
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice){
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );}
                  ).toList();

                },
            );},*/
          //),

        ) //ListTile
      )
    ); //GestureDetector
  }
}

class Constants{
  static final String _admin = 'Hacer admin';
  static final String _kick = 'Expulsar';

  static final List<String> choices = <String>[
    _admin,
    _kick
]  ;
}