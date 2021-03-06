import 'package:flutter/material.dart';
import 'package:TheyLendMe/Objects/obj.dart';
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/pages/user_details.dart';
import 'package:TheyLendMe/pages/group_details.dart';
import 'package:TheyLendMe/pages/contact_dialog.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:TheyLendMe/Objects/objState.dart';


//TODO: MyObjectDetails, from MyInventory
//      (en vez de "Contactar" y "Pedir prestado", "Borrar" y, en un futuro, "Modificar")
//      (actualAmount)

class ObjectDetails extends StatefulWidget {
  final Obj _object;

  ObjectDetails(this._object);

  @override
    _ObjectDetailsState createState() => _ObjectDetailsState();
}

class _ObjectDetailsState extends State<ObjectDetails> {
  int _currentAmount = 1;
  bool visibleDesc = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(0.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ]
        ),
        Container(
          constraints: BoxConstraints.expand( height: Theme.of(context).textTheme.display1.fontSize*1.1+200.0 ),
          alignment: Alignment.center,
          child: GestureDetector(
            child: Stack(
              children:[
                (widget._object.image!=null
                  ? Center(child: Image.network(widget._object.image))
                  : Center(child: Image.asset('images/def_obj_pic.png'))),
                (visibleDesc
                  ? Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                    ),
                    child: (widget._object.desc!=''
                      ? Text('\n'+widget._object.desc+'\n',
                        style: TextStyle(fontSize:Theme.of(context).textTheme.subtitle.fontSize,color:Colors.white),
                        textAlign: TextAlign.center
                      )
                      : Text('\n'+widget._object.name+'\n',
                        style: TextStyle(fontSize:Theme.of(context).textTheme.subtitle.fontSize,color:Colors.white),
                        textAlign: TextAlign.center
                      )
                    )
                  ) : Container(child: Text(''))
                ),
                Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: new FloatingActionButton(
                    child: Text("x"+widget._object.amount.toString(), style: Theme.of(context).textTheme.title),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ),
              ]
            ),
            onTap: () {
              setState( () {
                if (visibleDesc) {visibleDesc=false;} else {visibleDesc=true;}
              });
            }
          )
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget._object.name, overflow :TextOverflow.ellipsis, style: Theme.of(context).textTheme.title),
              Text(' de ', style: Theme.of(context).textTheme.subtitle),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        if (widget._object.owner is User) {
                          return UserDetails(widget._object.owner);
                        } else if (widget._object.owner is Group) {
                          return GroupDetails(widget._object.owner);
                        }
                      }
                  );
                
                },
                child: Text(widget._object.owner.name, style: Theme.of(context).textTheme.subtitle) //WIP: hacerlo más clickable
              )
            ]
          )
        ),
        Container(
          constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.5,
          ),
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton( //TODO: improve "Contact" button design
            height: 42.0,
            onPressed:(){
              if(UserSingleton().login){
                showDialog(
                context: context,
                builder: (BuildContext context){
                  return ContactDialog(widget._object.owner);
                }
              );} else{
                Navigator.of(context).pushNamed("/AuthPage");
              }
            },
            color: Theme.of(context).buttonColor,
            child: Text('Contactar', style: TextStyle(color: Colors.white)),
          )
        ),

        widget._object.objState.state == StateOfObject.DEFAULT ?
        Container(
          constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.5,
          ),
          child: MaterialButton( //TODO: improve "Request" button design
            height: 60.0,
            onPressed:() async{
              if(UserSingleton().login){
                if(widget._object.amount>1) {
                  // choose amount to requestObj
                  showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return new NumberPickerDialog.integer(
                        minValue: 1,
                        maxValue: widget._object.amount,
                        title: Text("Elige una cantidad"),
                        initialIntegerValue: _currentAmount
                      );
                    }
                  ).then<void>((int value) async{
                    if (value != null) {
                      setState(() { _currentAmount = value;});
                      widget._object.requestObj(amount: value).then((enviado){
                        if(!enviado){Fluttertoast.showToast(msg: "Solicitud enviada", toastLength: Toast.LENGTH_SHORT,);}
                        Navigator.pop(context);
                      });
                    }
                  });
                } else {
                  widget._object.requestObj().then((enviado){
                    if(!enviado){Fluttertoast.showToast(msg: "Solicitud enviada", toastLength: Toast.LENGTH_SHORT,);}
                    Navigator.pop(context);
                  });
                }
              } else{
                Navigator.of(context).pushNamed("/AuthPage");
              }
            },
            color: Theme.of(context).indicatorColor,
            child: Text('Pedir prestado', style: TextStyle(color: Colors.black)),
          )
        ) : Container(),
      ]
    );
  }
}