<?php class UsersClaims {

  //Class contructor
  public function UsersClaims($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'UsersClaims';
  }

  //the owner request the object with given idLoan
  //Returns the new idClaim
  function createClaim($idLoan, $claimMsg = null){
    if ($idLoan == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idLoan, claimMsg, claimDate) values (?, ?, now() );");
    $sth->execute(array($idLoan, $claimMsg));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //Delete a claim by its id
  function deleteClaim($idClaim){
    if ($idClaim == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idClaim = ?;");
    $sth->execute(array($idClaim));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //GET METHODS*****************************************************************
  //Return all the claims done by a user.
  function getClaimsByUser($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from UsersLoans where idObject in
        (select idObject from UsersObjects where idUser = ?)
      );
    ");
    $sth->execute(array($idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the claims done to a user.
  function getClaimsToUser($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from UsersLoans where idUser = ?);
    ");
    $sth->execute(array($idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the claims done for a given object
  function getClaimsByObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from UsersLoans where idObject = ?);
    ");
    $sth->execute(array($idObject));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return a claim by its id
  function getClaim($idClaim){
    if ($idClaim == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idClaim = ?;");
    $sth->execute(array($idClaim));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }
  //****************************************************************************

} ?>
