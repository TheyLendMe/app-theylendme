<?php class UsersHistory {

  //Class contructor
  public function UsersHistory($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'UsersHistory';
  }

  //Creates a new history entry
  function createHistoryEntry($idObject, $idUser, $returned, $amount = 1, $date = null){
    if ($idUser == null || $idObject == null || $returned === null) return null;

    if ($date == null){
      $sth = $this->pdo->prepare("Insert into $this->tableName
        (idUser, idObject, amount, returned, transactionDate) values (?, ?, ?, b?, now());");
      $sth->execute(array($idUser, $idObject, $amount, $returned));
    }else{
      $sth = $this->pdo->prepare("Insert into $this->tableName
        (idUser, idObject, amount, returned, transactionDate) values (?, ?, ?, b?, ?);");
      $sth->execute(array($idUser, $idObject, $amount, $returned, $date));
    }
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //Remove a entry by its id
  function deleteHistory($idHistory){
    if ($idHistory == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idHistory = ?;");
    $sth->execute(array($idHistory));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //GET METHODS*****************************************************************
  //Return all the entrys done by one user.
  //auth null -> loans done by me & to me, auth true -> loans done by me
  function getHistoryByUser($idUser, $auth = null){
    if ($idUser == null) return null;

    if ($auth == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName where
        idUser = ? or idObject in (select idObject from UsersObjects where idUser = ?);");
      $sth->execute(array($idUser, $idUser));
    }else{
      if ($auth == true){
        $sth = $this->pdo->prepare("Select * from $this->tableName where
          idObject in (select idObject from UsersObjects where idUser = ?);");
      }else{
        $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
      }
      $sth->execute(array($idUser));
    }
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all entrys for a given object
  function getHistoryByObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return a entry by its id
  function getHistory($idHistory){
    if ($idHistory == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idHistory = ?;");
    $sth->execute(array($idHistory));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }
  //****************************************************************************

} ?>
