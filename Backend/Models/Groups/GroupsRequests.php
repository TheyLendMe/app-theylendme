<?php class GroupsRequests {

  //Class contructor
  public function GroupsRequests($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'GroupsRequests';
  }

  //the user especified request the object with given id
  //Returns the new idRequest
  function createRequestByUser($idUser, $idObject, $idGroup = null, $amount = 1, $requestMsg = null){
    if ($idUser == null || $idObject == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idUser, idObject, idGroup, amount, requestMsg, date)
      values (?, ?, ?, ?, ?, now() );");
    $sth->execute(array($idUser, $idObject, $idGroup, $amount, $requestMsg));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //the group especified request the object with given id
  //Returns the new idRequest
  function createRequestByGroup($idGroup, $idObject, $idUser = null, $amount = 1, $requestMsg = null){
    if ($idGroup == null || $idObject == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idUser, idObject, idGroup, amount, requestMsg, date)
      values (?, ?, ?, ?, ?, now() );");
    $sth->execute(array($idUser, $idObject, $idGroup, $amount, $requestMsg));
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
  //Requests by user (to a group / by a group)
  //Requests to group
  //Requests by group
  //Requests by object (by group)
  //Requests by id

  //Return all the requests done by a user.
  //If id group is especified, return the requests to that group/by that group
  function getRequestsByUser($idUser, $idGroup = null, $toGroup = true){
    if ($idUser == null) return null;

    if ($idGroup == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
      $sth->execute(array($idUser));
    }else{
      if ($toGroup){
        $sth = $this->pdo->prepare("Select * from $this->tableName where
        idUser = ? and idObject in (select idObject from GroupsObjects where idGroup = ?);");
      }else{
        $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ? and idGroup = ?;");
      }
      $sth->execute(array($idUser, $idGroup));
    }
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the requests done to a group.
  function getRequestsToGroup($idGroup){
    if ($idGroup == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where
      idObject in (select idObject from GroupsObjects where idGroup = ?);");
    $sth->execute(array($idGroup));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the requests done by a group.
  function getRequestsByGroup($idGroup){
    if ($idGroup == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup = ?;");
    $sth->execute(array($idGroup));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the requests done for a given object
  //If a group is especified, just return the requests done by that group
  function getRequestsByObject($idObject, $idGroup = null){
    if ($idObject == null) return null;

    if ($idGroup == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ?;");
      $sth->execute(array($idObject));
    }else{
      $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ? and idGroup = ?;");
      $sth->execute(array($idObject, $idGroup));
    }
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
