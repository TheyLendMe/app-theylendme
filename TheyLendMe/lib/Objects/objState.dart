
import 'package:TheyLendMe/Objects/entity.dart';
import 'package:TheyLendMe/Singletons/UserSingleton.dart';



class ObjState{
  State _state;
  Entity _actual;
  int _idState;



  ObjState({State state = State.DEFAULT, Entity e, int id}){
    _idState = id;
    _actual = e != null ? e : UserSingleton.singleton.user;
    _state = state != null ? state : State.DEFAULT;
  }


  State get state => _state;
  Entity get actual => _actual;
  int get idState => _idState;

  set state (State state) => _state = state;
  set actual (Entity e) => _actual = e;
  set idState (int i) => _idState = i;



    

}


enum State{
  DEFAULT, LENDED, REQUESTED, LENT, BORROWED, CLAIMED, 
}