<?php class GroupsClaims {

  //Class contructor
  public function GroupsClaims($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'GroupsClaims';
  }

  //the owner request the object with given idLoan
  //Returns the new idClaim
  function createClaim($idLoan, $msg = null){
    if ($idLoan == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idLoan, claimMsg, claimDate) values (?, ?, now() );");
    $sth->execute(array($idLoan, $msg));
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
  //Return all the claims done by a group.
  function getClaimsByGroup($idGroup){
    if ($idGroup == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from GroupsLoans where idObject in
        (select idObject from GroupsObjects where idGroup = ?)
      );
    ");
    $sth->execute(array($idGroup));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the claims done by a group to group.
  //Internal claims if both groups are the same
  function getClaimsByGroupToGroup($idGroup, $idGroup2){
    if ($idGroup == null || $idGroup2 == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from GroupsLoans where idObject in
        (select idObject from GroupsObjects where idGroup = ?)
       and idGroup = ?);
    ");
    $sth->execute(array($idGroup, $idGroup2));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the claims done by a group to user.
  function getClaimsByGroupToUser($idGroup, $idUser){
    if ($idGroup == null || $idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from GroupsLoans where idObject in
        (select idObject from GroupsObjects where idGroup = ?)
       and idUser = ?);
    ");
    $sth->execute(array($idGroup, $idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the claims done to a user.
  //filter by group(requester) optional
  function getClaimsToUser($idUser, $idGroup = null){
    if ($idUser == null) return null;

    if ($idGroup == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
        (select idLoan from GroupsLoans where idUser = ?);
      ");
      $sth->execute(array($idUser));
    }else{
      $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
        (select idLoan from GroupsLoans where idUser = ? and idGroup = ?);
      ");
      $sth->execute(array($idUser, $idGroup));
    }
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the claims done to a group.
  function getClaimsToGroup($idGroup){
    if ($idGroup == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from GroupsLoans where idGroup = ?);
    ");
    $sth->execute(array($idGroup));

    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the claims done for a given object
  function getClaimsByObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idLoan in
      (select idLoan from GroupsLoans where idObject = ?);
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
