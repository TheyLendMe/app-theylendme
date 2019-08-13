<?php class GroupsMembers {

  //Class contructor
  public function GroupsMembers($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'GroupsMembers';
    $this->inmutableFields = ['idMember, idUser, idGroup'];
    $this->mutableFields = ['admin'];
  }

  //Add a user to a existing group, admin default is false
  //Returns the new idMember
  function addMember($idUser, $idGroup, $admin = false){
    if ($idUser == null || $idGroup == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idUser, idGroup, admin) values (?, ?, b?);");
    $sth->execute(array($idUser, $idGroup, $admin));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //VOID METHODS ***************************************************************
  //Update the mutable fields of the member
  function updateMember($idMember, $fieldName, $fieldValue){
    if ($idMember == null) return false;

    $updatedFields = 0;

    for( $i = 0; $i < count($fieldName); $i++) {
      if (in_array($fieldName[$i], $this->inmutableFields)) continue;
      if (!in_array($fieldName[$i], $this->mutableFields)) continue;

      if ($fieldName[$i] === 'admin'){
        $sth = $this->pdo->prepare("Update $this->tableName set ".$fieldName[$i]." = b? where idMember = ?;");
      }else{
        $sth = $this->pdo->prepare("Update $this->tableName set ".$fieldName[$i]." = ? where idMember = ?;");
      }
      $sth->execute(array($fieldValue[$i], $idMember));
      $upd = $sth->rowCount();
      if ($upd != 0) $updatedFields++;
    }

    return $updatedFields;
  }

  //remove a member from a group
  function removeMember($idMember){
    if ($idMember == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idMember = ?;");
    $sth->execute(array($idMember));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }
  //****************************************************************************

  //GET METHODS*****************************************************************
  //Return all membersEntrys by its user.
  //If admin is true, just the entrys where the user is an admin
  function getMembersByUser($idUser, $admin = false){
    if ($idUser == null) return null;

    if ($admin){
      $sth = $this->pdo->prepare("select * from $this->tableName where admin = true and idUser = ?;");
    }else{
      $sth = $this->pdo->prepare("select * from $this->tableName where idUser = ?;");
    }
    $sth->execute(array($idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all membersEntrys in a group
  //If admin is true, just return the admin members of that group
  function getMembersByGroup($idGroup, $admin = null){
    if ($idGroup == null) return null;

    if ($admin === null){
      $sth = $this->pdo->prepare("select * from $this->tableName where idGroup = ?;");
    }elseif ($admin === true){
      $sth = $this->pdo->prepare("select * from $this->tableName where admin = true and idGroup = ?;");
    }else{
      $sth = $this->pdo->prepare("select * from $this->tableName where admin = false and idGroup = ?;");
    }
    $sth->execute(array($idGroup));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  function getMember($idMember){
    if ($idMember == null) return false;

    $sth = $this->pdo->prepare("select * from $this->tableName where idMember = ?;");
    $sth->execute(array($idMember));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  function isMemberAndAdmin($idUser, $idGroup){
    if ($idGroup == null || $idUser == null) return false;

    $sth = $this->pdo->prepare("select * from $this->tableName where
      admin = true and idUser = ? and idGroup = ?;");
    $sth->execute(array($idUser, $idGroup));
    $exist = $sth->rowCount();
    return ($exist === 0 ? false : true);
  }

  function isMember($idUser, $idGroup){
    if ($idGroup == null || $idUser == null) return false;

    $sth = $this->pdo->prepare("select * from $this->tableName where idUser = ? and idGroup = ?;");
    $sth->execute(array($idUser, $idGroup));
    $exist = $sth->rowCount();
    return ($exist === 0 ? false : true);
  }
  //****************************************************************************

} ?>
