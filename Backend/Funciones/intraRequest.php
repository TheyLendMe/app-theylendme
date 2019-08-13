<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idObject'
]);
$optionalArgs = ArgumentManager::addOptionalPostArguments([
  'amount',
  'requestMsg'
]);

//Logic
$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsRequests = new GroupsRequests($pdo);
$GroupsLoans = new GroupsLoans($pdo);
$GroupsHistory = new GroupsHistory($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$object = $GroupsObjects->getObject($neededArgs['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData');
$group = $Groups->getGroup($object['idGroup']);
if ($group == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $object['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');
// }

//Check the autoloan property
$autoloan = $group['autoloan'];
//Check if the user id an admin
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $object['idGroup']);

if ( ($autoloan === true) || ($admin === true) ){
  //Check for item disponibility
  $lentAmount = $GroupsLoans->getLentAmountByObject($neededArgs['idObject']);
  $left = $object['amount'] - $lentAmount;
  if ($left < $optionalArgs['amount']) ResponseManager::returnErrorResponse('amount');

  //Make the loan
  $id = $GroupsLoans->createLoanByUser(
    $neededArgs['idUser'],
    $neededArgs['idObject'],
    $object['idGroup'],
    $optionalArgs['amount']
  );
  if ($id == null) ResponseManager::returnErrorResponse('invalidData');

  $hid = $GroupsHistory->createHistoryEntry_intraGroup(
    $neededArgs['idObject'],
    $neededArgs['idUser'], //Same user as doner and recipient -> admin or autoloan
    $neededArgs['idUser'],
    $object['idGroup'],
    false,
    $optionalArgs['amount']
  );

  //Return
  $json['idLoan'] = $id;
  ResponseManager::returnSuccessResponse(1, $json);
}
//else..

//Make the request
$id = $GroupsRequests->createRequestByUser(
  $neededArgs['idUser'],
  $neededArgs['idObject'],
  $object['idGroup'],
  $optionalArgs['amount'],
  $optionalArgs['requestMsg']
);
if ($id == null) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idRequest'] = $id;
ResponseManager::returnSuccessResponse(1, $json);
?>
