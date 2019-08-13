<?php class UsersRequests {

  //Class contructor
  public function UsersRequests($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'UsersRequests';
  }

  //the user especified request the object with given id
  //Returns the new idRequest
  function createRequest($idUser, $idObject, $amount = 1, $requestMsg = null){
    if ($idUser == null || $idObject == null) return false;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idUser, idObject, amount, requestMsg, date) values (?, ?, ?, ?, now() );");
    $sth->execute(array($idUser, $idObject, $amount, $requestMsg));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //Delete a request by its id
  function deleteRequest($idRequest){
    if ($idRequest == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idRequest = ?;");
    $sth->execute(array($idRequest));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //GET METHODS*****************************************************************
  //Return all the requests done by a user.
  function getRequestsByUser($idUser, $idObject = null){
    if ($idUser == null) return null;

    if ($idObject == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
      $sth->execute(array($idUser));
      while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
        $data[] = $row;
      }
    }else{
      $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ? and idObject = ?;");
      $sth->execute(array($idUser, $idObject));
      $data = $sth->fetch(PDO::FETCH_ASSOC);
    }
    return $data;
  }

  //Return all the requests done to a user.
  function getRequestsToUser($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where
      idObject in (select idObject from UsersObjects where idUser = ?);");
    $sth->execute(array($idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the requests done for a given object
  function getRequestsByObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return a request entry by its id
  function getRequest($idRequest){
    if ($idRequest == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idRequest = ?;");
    $sth->execute(array($idRequest));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }
  //****************************************************************************

} ?>
