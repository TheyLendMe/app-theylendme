<?php class UsersLoans {

  //Class contructor
  public function UsersLoans($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'UsersLoans';
  }

  //Loan the given object to the given user
  //Returns the new idLoan
  function createLoan($idObject, $idUser, $amount = 1){
    if ($idUser == null || $idObject == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idUser, idObject, amount, date) values (?, ?, ?, now() );");
    $sth->execute(array($idUser, $idObject, $amount));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //Remove a loan by its id
  function deleteLoan($idLoan){
    if ($idLoan == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idLoan = ?;");
    $sth->execute(array($idLoan));

    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //GET METHODS*****************************************************************
  //Return all the loans done by one user.
  function getLoansByUser($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where
      idObject in (select idObject from UsersObjects where idUser = ?);");
    $sth->execute(array($idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the loans done to one user.
  function getLoansToUser($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the requests done for a given object
  function getLoansByObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return a loan entry by its id
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
