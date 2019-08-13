<?php class UsersEstadistics {
//getUserInfo, createObject, deleteObject, returnLendedObject, lendObject
//getFullHistory, getObjectHistory, deleteClaim, declineJoinRequest, downgradeAdmin, deleteGClaim
//getGroupObjects (permission to no members when group is not private)
//++ getFullGHistory + getGObjectHistory
//++ getGroupInfo + GroupsInfoModel + models_loader ++ ----> createGObject, deleteGObject, intraRequest, lendGObject, returnLentGObject

  //Class contructor
  public function UsersEstadistics($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'UsersEstadistics';
  }

  //create row to user
  function initEstadistics($idUser){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idUser) values (?);");
    $sth->execute(array($idUser));
    $created = $sth->rowCount();
    return ($created === 0 ? false : true);
  }

  function haveEstadistics($idUser){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    $exists = $sth->rowCount();
    return ($exists === 0 ? false : true);
  }

  //Delete a row by its user id
  function deleteEstadistics($idUser){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //Return estadistics by user : getUserInfo
  function getUserEstadistics($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  //Update methods *****************************************************************************************
  //OBJECTS PUBLISHED : createObject & deleteObject
  function incrementObjectsPublished($idUser, $amount = 1){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Update $this->tableName set objectsPublished = objectsPublished + ? where idUser = ?;");
    $sth->execute(array($amount, $idUser));
    $upd = $sth->rowCount();
    return ($upd === 0 ? false : true);
  }
  function decrementObjectsPublished($idUser, $amount = 1){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Update $this->tableName set objectsPublished = objectsPublished - ? where idUser = ?;");
    $sth->execute(array($amount, $idUser));
    $upd = $sth->rowCount();
    return ($upd === 0 ? false : true);
  }
  //LOANS DONE : lendObject (by me)
  function incrementLoansDone($idUser, $amount = 1){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Update $this->tableName set loansDone = loansDone + ? where idUser = ?;");
    $sth->execute(array($amount, $idUser));
    $upd = $sth->rowCount();
    return ($upd === 0 ? false : true);
  }
  //LOANS RECEIVED : lendObject (to me)
  function incrementLoansReceived($idUser, $amount = 1){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Update $this->tableName set loansReceived = loansReceived + ? where idUser = ?;");
    $sth->execute(array($amount, $idUser));
    $upd = $sth->rowCount();
    return ($upd === 0 ? false : true);
  }
  //LOANS RETURNED : returnLendedObject (loan to me)
  function incrementLoansReturned($idUser, $amount = 1){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Update $this->tableName set loansReturned = loansReturned + ? where idUser = ?;");
    $sth->execute(array($amount, $idUser));
    $upd = $sth->rowCount();
    return ($upd === 0 ? false : true);
  }
  //********************************************************************************************************************


} ?>
