<?php class AccountingManager{

  // public static $tfno_num;
  private static $request_id;
  private static $request_date;
  private static $request_path;
  private static $ip = [];
  private static $posted;
  private static $file;

  private static $data;

  public static function setup($data_path){
    //Load json
    if (file_exists($data_path)){
      $string_data = file_get_contents($data_path);
      self::$data = json_decode($string_data, true);
    }else{
      self::$data['entrys'] = array(
        'input' => [],
        'output' => []
      );
    }

    //Load data from server enviroment
    self::$request_id = rand(1, 50000);
    self::$request_date = date('Y-m-d H:i:s');
    self::$request_path = $_SERVER['REQUEST_URI'];
    self::$ip = array(
      'HTTP_CLIENT_IP' => @$_SERVER['HTTP_CLIENT_IP'],
      'HTTP_X_FORWARDED_FOR' => @$_SERVER['HTTP_X_FORWARDED_FOR'],
      'REMOTE_ADDR' => $_SERVER['REMOTE_ADDR']
    );
    self::$posted = $_POST;
    unset(self::$posted['token']);                          //PRIVACY
    self::$file = ((isset($_FILES['image']) == false)
      ? false
      : array(
        'original_name' => $_FILES['image']['name'],
        'type' => $_FILES['image']['type'],
        'original_size' => $_FILES['image']['size']
      )
    );
  }

  public static function recordInput(){
    $push = array(
      'id' => self::$request_id,
      'date' => self::$request_date,
      'request_path' => self::$request_path,
      'ip-data' => self::$ip,
      'post-data' => self::$posted,
      'with_file' => self::$file
    );

    self::$data['entrys']['input'][] = $push;
  }

  public static function recordResponse($json_response, $status){
    $response_without_data = $json_response;
    unset($response_without_data['responseData']);
    $push = array(
      'status' => $status,
      'id' => self::$request_id,
      'date' => self::$request_date,
      // 'response' => $json_response //with data         //PRIVACY
      'response' => $response_without_data
    );

    self::$data['entrys']['output'][] = $push;
  }

  public static function save($data_path){
    $string_data = json_encode(self::$data);
    file_put_contents($data_path, $string_data);
  }

} ?>
