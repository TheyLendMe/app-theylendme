<?php class Groups {

  //Class contructor
  public function Groups($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'Groups';
    $this->inmutableFields = ['idGroup', 'foundDate'];
    $this->mutableFields = ['groupName', 'private', 'autoloan', 'email', 'tfno', 'info', 'imagen'];
  }

  //Creates a new group, mutable fields optional.
  //Returns the new idGroup
  function createGroup($groupName = null, $private = true, $autoloan = false, $email = null, $tfno = null, $info = null){
    $sth = $this->pdo->prepare("Insert into $this->tableName
      (groupName, private, autoloan, email, tfno, info, foundDate)
      values (?, b?, b?, ?, ?, ?, now() );");
    $sth->execute(array($groupName, $private, $autoloan, $email, $tfno, $info));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //VOID METHODS ***************************************************************
  //Update the mutable fields of the group
  function updateGroup($idGroup, $fieldName, $fieldValue){
    if ($idGroup == null) return false;

    $updatedFields = 0;

    for( $i = 0; $i < count($fieldName); $i++) {
      if (in_array($fieldName[$i], $this->inmutableFields)) continue;
      if (!in_array($fieldName[$i], $this->mutableFields)) continue;

      if ($fieldName[$i] === 'private' || $fieldName[$i] === 'autoloan'){
        $sth = $this->pdo->prepare("Update $this->tableName set ".$fieldName[$i]." = b? where idGroup = ?;");
      }else{
        $sth = $this->pdo->prepare("Update $this->tableName set ".$fieldName[$i]." = ? where idGroup = ?;");
      }
      $sth->execute(array($fieldValue[$i], $idGroup));
      $upd = $sth->rowCount();
      if ($upd != 0) $updatedFields++;
    }

    return $updatedFields;
  }

  //Delete a group by its id
  function deleteGroup($idGroup){
    if ($idGroup == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idGroup = ?;");
    $sth->execute(array($idGroup));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }
  //****************************************************************************

  //GET METHODS*****************************************************************
  //Returns a group by its id
  function getGroup($idGroup = null){
    if ($idGroup == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName;");
      $sth->execute();
      while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
        $data[] = $row;
      }
    }else{
      $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup = ?;");
      $sth->execute(array($idGroup));
      //ONE ROW EXPECTED
      $data = $sth->fetch(PDO::FETCH_ASSOC);
    }
    return $data;
  }

  //Return all the groups configured as public
  function getPublicGroups(){
    $sth = $this->pdo->prepare("Select * from $this->tableName where private = false;");
    $sth->execute();
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //get all the groups where a given user is member
  //If second argument is true, return just groups where the given user is admin
  function getGroupsByUser($idUser, $admin = false){
    if ($idUser == null) return null;

    if($admin){
      $sth = $this->pdo->prepare("select * from Groups where
        idGroup in (select idGroup from GroupsMembers where admin = true and idUser = ?);");
    }else{
      $sth = $this->pdo->prepare("select * from Groups where
        idGroup in (select idGroup from GroupsMembers where idUser = ?);");
    }
    $sth->execute(array($idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return group where its name match a specific pattern
  function getGroupByName($pattern){
    if ($pattern == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where groupName like ?;");
    $sth->execute(array("%$pattern%"));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return the table fields -> NULL - all, TRUE - mutable, FALSE - inmutable
  function getFields($mutable = null){
    if ($mutable === null){
      $fields = array_merge($this->inmutableFields, $this->mutableFields);
    }elseif ($mutable === true){
      $fields = $this->mutableFields;
    }elseif ($mutable === false){
      $fields = $this->inmutableFields;
    }
    return $fields;
  }
  //****************************************************************************
} ?>
