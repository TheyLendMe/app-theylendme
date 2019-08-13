<?php class GroupsHistory {

  //Class contructor
  public function GroupsHistory($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'GroupsHistory';
  }

  function createHistoryEntry_intraGroup($idObject, $idUser_doner, $idUser_recipient, $idGroup, $returned, $amount = 1){
    if ($idUser == null || $idObject == null || $idGroup == null || $returned == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idObject, doner, recipient, idGroup, returned, amount, transactionDate) values (?, ?, ?, ?, b?, ?, now() );");
    $sth->execute(array($idObject, $idUser_doner, $idUser_recipient, $idGroup, $returned, $amount));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  function createHistoryEntry_toOtherGroup($idObject, $idUser_doner, $idUser_recipient, $idGroup, $returned, $amount = 1){
    if ($idUser == null || $idObject == null || $idGroup == null || $returned == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idObject, doner, recipient, idGroup, returned, amount, transactionDate) values (?, ?, ?, ?, b?, ?, now() );");
    $sth->execute(array($idObject, $idUser_doner, $idUser_recipient, $idGroup, $returned, $amount));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  function createHistoryEntry_toOtherUser($idObject, $idUser_doner, $idUser_recipient, $returned, $amount = 1){
    if ($idUser == null || $idObject == null || $returned == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idObject, doner, recipient, idGroup, returned, amount, transactionDate) values (?, ?, ?, ?, b?, ?, now() );");
    $sth->execute(array($idObject, $idUser_doner, $idUser_recipient, null, $returned, $amount));
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

  //Return a entry by its id
  function getHistory($idHistory){
    if ($idHistory == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idHistory = ?;");
    $sth->execute(array($idHistory));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  // function getHistoryByUser
  //****************************************************************************

} ?>
