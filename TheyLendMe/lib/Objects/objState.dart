import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';

class ObjState{
  StateOfObject _state;
  String _msg;
  Entity _actual, _next;

  DateTime _date;
  int _amount;
  int _idState;
  int _fromID;

  ObjState({StateOfObject state = StateOfObject.DEFAULT, Entity actual, Entity next, int id, int amount, String msg, dynamic date, int fromID}){
    _idState = id;
    _actual = actual != null ? actual : UserSingleton().user;
    _next = next != null ? next : UserSingleton().user;
    _state = state != null ? state : StateOfObject.DEFAULT;
    _msg = msg;
    //_date = date;
    _fromID = fromID;
    _amount = amount;
  }

  static StateOfObject getObjState(String stateType){
    Map<String, StateOfObject> m= new Map();
    m['requested'] = StateOfObject.REQUESTED;
    m['claims'] = StateOfObject.CLAIMED;

    return m[stateType];
  }

class GroupObjState extends ObjState{
  User _actualUser;
  User _nextUser;

  GroupObjState({StateOfObject state, Entity actual, Entity next, int id, int amount, String msg, dynamic date, int fromID, User actualUser, User nextUser, bool notFromAGroup = true}) : 
  super(state : state, actual : actual, next : next, id: id, amount : amount, msg :msg, date : date, fromID : fromID){
    this._actualUser = actualUser;
    this._nextUser = nextUser;
    if(notFromAGroup){this._next = null;}
  }
  User get actualUser => _actualUser;
  User get nextUser => _nextUser;


  set actualUser(User actualUser) => _actualUser = actualUser;
  set nextUser(User nextUser) => _nextUser = nextUser;

  bool intraGroup(){return actual.idEntity == next.idEntity;}
  bool notFromGroup(){return (_nextUser != null && next == null) || (_actualUser != null && actual == null);}
}

enum StateOfObject{
  DEFAULT, LENT, REQUESTED, CLAIMED,
}