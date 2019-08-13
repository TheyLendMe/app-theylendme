<?php class GroupsLoans {

  //Class contructor
  public function GroupsLoans($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'GroupsLoans';
  }

  //Loan the given object to the given user
  //Returns the new idRequest
  function createLoanByUser($idUser, $idObject, $idGroup = null, $amount = 1){
    if ($idUser == null || $idObject == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idUser, idObject, idGroup, amount, date)
      values (?, ?, ?, ?, now() );");
    $sth->execute(array($idUser, $idObject, $idGroup, $amount));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //the group especified request the object with given id
  //Returns the new idRequest
  function createLoanByGroup($idGroup, $idObject, $idUser = null, $amount = 1){
    if ($idGroup == null || $idObject == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idUser, idObject, idGroup, amount, date)
      values (?, ?, ?, ?, now() );");
    $sth->execute(array($idUser, $idObject, $idGroup, $amount));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //Delete a loan by its id
  function deleteLoan($idLoan){
    if ($idLoan == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idLoan = ?;");
    $sth->execute(array($idLoan));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //GET METHODS*****************************************************************
  //Return all the loans done by a group. (internas/externas/all)
  function getLoansByGroup($idGroup, $internas = null){
    if($idGroup == null) return null;

    if ($internas === null){
      $sth = $this->pdo->prepare("Select * from $this->tableName where
        idObject in (select idObject from GroupsObjects where idGroup = ?);");
      $sth->execute(array($idGroup));
    }else{
      if($internas === true){
        $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup = ? and
          idObject in (select idObject from GroupsObjects where idGroup = ?);");
      }elseif($internas === false){
        $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup != ? and
          idObject in (select idObject from GroupsObjects where idGroup = ?);");
      }
      $sth->execute(array($idGroup, $idGroup));
    }
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the loans done to a group. (filter by the other group)
  function getLoansToGroup($idGroup, $idFilter = null){
    if ($idGroup == null) return null;

    if ($idFilter == null) {
      $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup = ?;");
      $sth->execute(array($idGroup));
    }else {
      $sth = $this->pdo->prepare("Select * from $this->tableName where
        idGroup = ? and idObject in (select idObject from GroupsObjects where idGroup = ?);");
      $sth->execute(array($idGroup, $idFilter));
    }
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the loans done to a user. (internas a un grupo/all)
  function getLoansToUser($idUser, $idGroup = null){
    if ($idUser == null) return null;

    if ($idGroup == null) {
      $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
      $sth->execute(array($idUser));
    }else {
      $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ? and
        idObject in (select idObject from GroupsObjects where idGroup = ?);");
      $sth->execute(array($idUser, $idGroup));
    }

    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //loan by object
  function getLoansByObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Loan by id
  function getLoan($idLoan){
    if ($idLoan == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan = ?;");
    $sth->execute(array($idLoan));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  function getLentAmountByObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select sum(amount) as 'sum' from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data['sum'];
  }
  //****************************************************************************

} ?>
