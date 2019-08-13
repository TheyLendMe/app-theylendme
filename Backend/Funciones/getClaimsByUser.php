<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersLoans = new UsersLoans($pdo);
$UsersClaims = new UsersClaims($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$objects = $UsersObjects->getObjects($neededArgs['idUser']);
$claims = $UsersClaims->getClaimsByUser($neededArgs['idUser']);

$result = $objects;
for ($i=0; $i < count($result) ; $i++) {
  $result[$i]['claimN'] = 0;
  $result[$i]['claims'] = [];

  foreach ($claims as &$cl) {
    $loan = $UsersLoans->getLoan($cl['idLoan']);
    if ($loan['idObject'] === $result[$i]['idObject']){
      $owner = $usersInstance->getUser($result[$i]['idUser']);
      $cl['objectData']  = array(
        'owner_id' => $owner['idUser'],
        'owner_name' => $owner['nickname'],
        'amount' => $loan['amount'],
        'lentDate' => $loan['date']
      );
      $keeper = $usersInstance->getUser($loan['idUser']);
      $cl['claim_target'] = $keeper['nickname'];

      $result[$i]['claimN']++;
      $result[$i]['claims'][] = $cl;
      break;
    }
  }
}

//Remove the objects with no claims
$response = [];
foreach ($result as &$obj) {
  if ($obj['claimN'] > 0){
    $response[] = $obj;
  }
}

ResponseManager::returnSuccessResponse(3, $response);
?>
