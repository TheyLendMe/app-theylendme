<?php class JoinRequests {

  //Class contructor
  public function JoinRequests($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'JoinRequests';
  }

  //A use request to join the given group
  //Returns the new idRequest
  function addJoinRequest($idUser, $idGroup){
    if ($idUser == null || $idGroup == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idUser, idGroup) values (?, ?);");
    $sth->execute(array($idUser, $idGroup));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //VOID METHODS ***************************************************************
  //remove a JoinRequest to a group
  function removeRequest($idRequest){
    if ($idRequest == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idRequest = ?;");
    $sth->execute(array($idRequest));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  function removeUserRequests($idUser){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  function removeRequestsToGroup($idGroup){
    if ($idGroup == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idGroup = ?;");
    $sth->execute(array($idGroup));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }
  //****************************************************************************

  //GET METHODS*****************************************************************
  //Return all requestsEntrys by its user.
  function getRequestsByUser($idUser, $idGroup = null){
    if ($idUser == null) return null;

    if ($idGroup == null){
      $sth = $this->pdo->prepare("select * from $this->tableName where idUser = ?;");
      $sth->execute(array($idUser));
    }else{
      $sth = $this->pdo->prepare("select * from $this->tableName where idUser = ? and idGroup = ?;");
      $sth->execute(array($idUser, $idGroup));
    }
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all requests to a group
  function getRequestsByGroup($idGroup){
    if ($idGroup == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where idGroup = ?;");
    $sth->execute(array($idGroup));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  function getRequest($idRequest){
    if ($idRequest == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where idRequest = ?;");
    $sth->execute(array($idRequest));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  function haveRequestToGroup($idUser, $idGroup){
    if ($idUser == null || $idGroup == null) return false;

    $sth = $this->pdo->prepare("select * from $this->tableName where idUser = ? and idGroup = ?;");
    $sth->execute(array($idUser, $idGroup));
    $exists = $sth->rowCount();
    return ($exists === 0 ? false : true);
    }
  //****************************************************************************

} ?>
