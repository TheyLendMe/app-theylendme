<?php class ErrorManager{

  //Error code >100 are shown to user
  private static $ERRORS = array(
    //Connection to the db - Function include
    'connection' => array('code' => -1, 'msg' => 'could not connect to the database'),
    'function'   => array('code' => -2, 'msg' => 'the requested function could not be found'),
    //Required parameter not suplied
    'idUser'      => array('code' => 1, 'msg' => 'idUser must be provided'),
    'idObject'    => array('code' => 2, 'msg' => 'idObject must be provided'),
    'idRequest'   => array('code' => 3, 'msg' => 'idRequest must be provided'),
    'idLoan'      => array('code' => 4, 'msg' => 'idLoan must be provided'),
    'idMember'    => array('code' => 5, 'msg' => 'idMember must be provided'),
    'idGroup'     => array('code' => 6, 'msg' => 'idGroup must be provided'),
    'fieldName'   => array('code' => 7, 'msg' => 'fieldName must be provided'),
    'fieldValue'  => array('code' => 8, 'msg' => 'fieldValue must be provided'),
    'privateCode' => array('code' => 9, 'msg' => 'privateCode must be provided'),
    'updateRequest' => array('code' => 10, 'msg' => 'updateRequest must be provided'),
    //Auth errors
    'permission'   => array('code' => 111, 'msg' => 'Permission error'),
    'token'        => array('code' => 112, 'msg' => 'Token not provided'),
    'invalidToken' => array('code' => 113, 'msg' => 'Provided token is not valid'),
    'invalidUser'  => array('code' => 114, 'msg' => 'Provided user is not valid'),
    'existingUser' => array('code' => 115, 'msg' => 'The user already exists'),
    'verifyEmail'  => array('code' => 116, 'msg' => 'Email must be verificated'),
    'auth'         => array('code' => 117, 'msg' => 'The auth have failed'),
    'registerError'=> array('code' => 118, 'msg' => 'Unknown register error, try again please'),
    //Invalid data provided
    'invalidData' => array('code' => 120, 'msg' => 'The provided data is not valid'),
    'array'       => array('code' => 21, 'msg' => 'Wrong array format provided'),
    'arrayLength' => array('code' => 22, 'msg' => 'Unconsistent array length'),
    'emptyUpdate' => array('code' => 123, 'msg' => 'Nothing to update'),
    'jsonError' => array(
      JSON_ERROR_DEPTH => array('code' => 124, 'msg' => 'Maximum stack depth exceeded'),
      JSON_ERROR_STATE_MISMATCH => array('code' => 124, 'msg' => 'State mismatch (invalid or malformed JSON)'),
      JSON_ERROR_CTRL_CHAR => array('code' => 124, 'msg' => 'Control character error, possibly incorrectly encoded'),
      JSON_ERROR_SYNTAX => array('code' => 124, 'msg' => 'Syntax error'),
      JSON_ERROR_UTF8 => array('code' => 124, 'msg' => 'Malformed UTF-8 characters, possibly incorrectly encoded')
    ),
    //Ilegal join request atempt
    'member'      => array('code' => 131, 'msg' => 'You already are a member of that group'),
    'requested'   => array('code' => 132, 'msg' => 'You have already request to join that group'),
    'invalidCode' => array('code' => 133, 'msg' => 'Invalid or expired code provided'),
    'kickYourself' => array('code' => 134, 'msg' => 'You can not kick yourself'),
    'leaveWithLoans' => array('code' => 135, 'msg' => 'You can not leave without return all the loans'),
    'kickWithLoans' => array('code' => 136, 'msg' => 'You can not kick a user with not returned loans'),
    //Ilegal request / lend atempt
    'amount'   => array('code' => 141, 'msg' => 'You have not the requested amount to lend'),
    'yourself' => array('code' => 142, 'msg' => 'You cant request to yourself'),
    //Image errors
    'imageExt'    => array('code' => 151, 'msg' => 'Image extension not allowed'),
    'imageSize'   => array('code' => 152, 'msg' => 'Image max size exceded'),
    'imageSaving' => array('code' => 153, 'msg' => 'Error while saving the image'),
    'directory' => array('code' => 154, 'msg' => 'Error while creating the directory'),
    'imageSaving2' => array('code' => 155, 'msg' => 'Error while saving the image path'),
    //Wrong variable type received
    'idUserType' => array('code' => 61, 'msg' => 'wrong type in idUser var'),
    'tokenType' => array('code' => 62, 'msg' => 'wrong type in token var'),
    'idLoanType' => array('code' => 63, 'msg' => 'wrong type in idLoan var'),
    'idGroupType' => array('code' => 64, 'msg' => 'wrong type in idGroup var'),
    'idObjectType' => array('code' => 65, 'msg' => 'wrong type in idObject var'),
    'idRequestType' => array('code' => 66, 'msg' => 'wrong type in idRequest var'),
    'idMemberType' => array('code' => 67, 'msg' => 'wrong type in idMember var'),
    'fieldNameType' => array('code' => 68, 'msg' => 'wrong type in fieldName var'),
    'fieldValueType' => array('code' => 69, 'msg' => 'wrong type in fieldValue var'),
    'nameType' => array('code' => 70, 'msg' => 'wrong type in name var'),
    'amountType' => array('code' => 71, 'msg' => 'wrong type in amount var'),
    'requestMsgType' => array('code' => 72, 'msg' => 'wrong type in requestMsg var'),
    'claimMsgType' => array('code' => 73, 'msg' => 'wrong type in claimMsg var'),
    'privateType' => array('code' => 74, 'msg' => 'wrong type in private var'),
    'infoType' => array('code' => 75, 'msg' => 'wrong type in info var'),
    'groupNameType' => array('code' => 76, 'msg' => 'wrong type in groupName var'),
    'autoloanType' => array('code' => 77, 'msg' => 'wrong type in autoloan var'),
    'emailType' => array('code' => 78, 'msg' => 'wrong type in email var'),
    'tfnoType' => array('code' => 79, 'msg' => 'wrong type in tfno var'),
    'nicknameType' => array('code' => 80, 'msg' => 'wrong type in nickname var'),
    'descType' => array('code' => 81, 'msg' => 'wrong type in desc var'),
    'idOtherUser' => array('code' => 82, 'msg' => 'wrong type in idOtherUser var'),
    'Type' => array('code' => 83, 'msg' => 'wrong name in provided var')
  );

  public static function getErrorCode($idError){
    return self::$ERRORS[$idError]['code'];
  }

  public static function getErrorMsg($idError){
    return self::$ERRORS[$idError]['msg'];
  }

  public static function getJsonErrorCode($idError){
    return self::$ERRORS['jsonError'][$idError]['code'];
  }

  public static function getJsonErrorMsg($idError){
    return self::$ERRORS['jsonError'][$idError]['msg'];
  }

}?>
