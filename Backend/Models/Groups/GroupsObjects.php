<?php class GroupsObjects {

  //Class contructor
  public function GroupsObjects($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'GroupsObjects';
    $this->inmutableFields = ['idObject', 'idGroup', 'creationDate']; //< idGroup shouldn't mutate?¿?¿?¿
    $this->mutableFields = ['imagen', 'amount', 'name', 'descr'];
  }

  //Creates an object asociated with some user. Extra info is optional
  //Returns the new idObject
  function createObject($idGroup, $name = null, $imagen = null, $amount = 1, $desc = null){
    if ($idGroup == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idGroup, name, imagen, amount, descr, creationDate) values (?, ?, ?, ?, ?, now() );");
    $sth->execute(array($idGroup, $name, $imagen, $amount, $desc));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //VOID METHODS ***************************************************************
  //Sets a given value in one given field in a given object(by its id)
  function updateObject($idObject, $fieldName, $fieldValue){
    if ($idObject == null) return false;

    $updatedFields = 0;

    for( $i = 0; $i < count($fieldName); $i++) {
      if (in_array($fieldName[$i], $this->inmutableFields)) continue;
      if (!in_array($fieldName[$i], $this->mutableFields)) continue;

      $sth = $this->pdo->prepare("Update $this->tableName set ".$fieldName[$i]." = ? where idObject = ?;");
      $sth->execute(array($fieldValue[$i], $idObject));
      $upd = $sth->rowCount();
      if ($upd != 0) $updatedFields++;
    }

    return $updatedFields;
  }

  //Delete a object by its id
  function deleteObject($idObject){
    if ($idObject == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //Delete all the objects owned by a group
  function deleteObjectsByGroup($idGroup){
    if ($idGroup == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idGroup = ?;");
    $sth->execute(array($idGroup));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }
  //****************************************************************************

  //GET METHODS*****************************************************************
  //Returns an object by its id
  function getObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    //ONE ROW EXPECTED
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  //Returns a list of objects by the group id (can be specified or not)
  //If not specified -> return all the objects in the DDBB
  //If second argument is false, return all the objects except the especified
  function getObjects($idGroup = null, $propietary = true){
    if ($idGroup == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName;");
      $sth->execute();
      while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
        $data[] = $row;
      }
    }else{
      if ($propietary){
        $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup = ?;");
      }else{
        $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup != ?;");
      }
      $sth->execute(array($idGroup));
      while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
        $data[] = $row;
      }
    }
    return $data;
  }

  function getPublicObjects(){
    $sth = $this->pdo->prepare("Select * from $this->tableName where idGroup in
      (select idGroup from Groups where private=false);");
    $sth->execute();
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //get the objects one group keep -> group's obj - Loans to other + Loans to the group
  function getObjectsByKeeper($idGroup){
    if ($idGroup == null) return null;

    $sth = $this->pdo->prepare("select * from GroupsObjects where (
      (idGroup = ? and not idObject in (select idObject from GroupsLoans) )
      or
      (idObject in (select from GroupsLoans where $idGroup = ?) )
    );");
    $sth->execute(array($idGroup, $idGroup));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return objects where its name match a specific pattern
  function getObjectsByName($pattern){
    if ($pattern == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where name like ?;");
    $sth->execute(array("%$pattern%"));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return object which have a tag asociated which match the pattern
  function getObjectByTag($pattern){
    if ($pattern == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where idObject in
      (select idObject from GroupsTags where idTag in
        (select idTag from Tags where tag like ?)
      )
    ;");
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
