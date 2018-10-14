
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';



class ObjState{
  StateOfObject _state;
  Entity _actual;
  int _idState;



  ObjState({StateOfObject state = StateOfObject.DEFAULT, Entity e, int id}){
    _idState = id;
    _actual = e != null ? e : UserSingleton.singleton.user;
    _state = state != null ? state : StateOfObject.DEFAULT;
  }


  StateOfObject get state => _state;
  Entity get actual => _actual;
  int get idState => _idState;

  set state (StateOfObject state) => _state = state;
  set actual (Entity e) => _actual = e;
  set idState (int i) => _idState = i;



    

}


enum StateOfObject{
  DEFAULT, LENDED, REQUESTED, LENT, BORROWED, CLAIMED, 
}