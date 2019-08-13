<?php class ResponseManager{

  private static function getResponseModel(){
    return (array(
      'error' => false,
      'errorCode' => 0,             //NO ERROR
      'errorMsg' => '',
      'responseType' => 0,          //ERROR
      'responseData' => null
    ));
  }

  public static function returnErrorResponse($idError, $json_error = false){
    $response = self::getResponseModel();

    $response['error'] = true;
    $response['errorCode'] = ($json_error) ? ErrorManager::getJsonErrorCode($idError) : ErrorManager::getErrorCode($idError);
    $response['errorMsg'] = ($json_error) ? ErrorManager::getJsonErrorMsg($idError) : ErrorManager::getErrorMsg($idError);

    AccountingManager::recordResponse($response, 'failure');
    AccountingManager::save('../../api_logs/logs.json');

    die( json_encode($response) );
  }

  public static function returnSuccessResponse($idRequest, $data){
    $response = self::getResponseModel();

    $response['responseType'] = $idRequest;
    $response['responseData'] = $data;

    AccountingManager::recordResponse($response, 'success');
    AccountingManager::save('../../api_logs/logs.json');

    //This try to avoid malformed UTF-8 by ilegal chars in the db
    // $response = mb_convert_encoding($response, 'UTF-8', 'UTF-8');
    // die( json_encode($response) );

    $encoded_response = json_encode($response);
    static $ERRORS = array(
      JSON_ERROR_NONE => 'No error',
      JSON_ERROR_DEPTH => 'Maximum stack depth exceeded',
      JSON_ERROR_STATE_MISMATCH => 'State mismatch (invalid or malformed JSON)',
      JSON_ERROR_CTRL_CHAR => 'Control character error, possibly incorrectly encoded',
      JSON_ERROR_SYNTAX => 'Syntax error',
      JSON_ERROR_UTF8 => 'Malformed UTF-8 characters, possibly incorrectly encoded'
    );

    $error = json_last_error();
    $error_text = isset($ERRORS[$error]) ? $ERRORS[$error] : 'Unknown error';
    if ($error_text === 'No error'){
      die( $encoded_response );
    }else{
      die( $error_text );
    }
  }

}?>
