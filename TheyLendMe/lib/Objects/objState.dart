
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';



class ObjState{
  StateOfObject _state;
  String _msg;
  Entity _actual, _next;
  int _idState;

  ObjState({StateOfObject state = StateOfObject.DEFAULT, Entity actual, Entity next, int id, String msg}){
    _idState = id;
    _actual = actual != null ? actual : UserSingleton().user;
    _next = next;
    _state = state != null ? state : StateOfObject.DEFAULT;
    _msg = msg;
  }

  static StateOfObject getObjState(String stateType){
    Map<String, StateOfObject> m= new Map();
    m['requested'] = StateOfObject.REQUESTED;
    m['claims'] = StateOfObject.CLAIMED;

    return m[stateType];
  }


  StateOfObject get state => _state;
  Entity get actual => _actual;
  Entity get next => _next;
  int get idState => _idState;
  set state (StateOfObject state) => _state = state;
  set actual (Entity e) => _actual = e;
  set idState (int i) => _idState = i;
}
enum StateOfObject{
  DEFAULT, LENDED, REQUESTED, LENT, BORROWED, CLAIMED, 
}