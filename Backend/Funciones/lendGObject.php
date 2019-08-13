<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idRequest'
]);

$GroupsLoans = new GroupsLoans($pdo);
$GroupsRequests = new GroupsRequests($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsHistory = new GroupsHistory($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$request = $GroupsRequests->getRequest($neededArgs['idRequest']);
if ($request == null) ResponseManager::returnErrorResponse('invalidData');
$requestedObject = $GroupsObjects->getObject($request['idObject']);
if ($requestedObject == null) ResponseManager::returnErrorResponse('invalidData');
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'],$requestedObject['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission'); // You have to be an admin of the owner group
// }

//Check that we have enough items to lend
$lentAmount = $GroupsLoans->getLentAmountByObject($request['idObject']);
$left = $requestedObject['amount'] - $lentAmount;
if ($left < $request['amount']) ResponseManager::returnErrorResponse('amount');

//Make the loan
//IntraGroup
if ($request['idGroup'] === $requestedObject['idGroup']) {
  $idLoan = $GroupsLoans->createLoanByUser(
    $request['idUser'],
    $request['idObject'],
    $request['idGroup'],
    $request['amount']
  );

  $hid = $GroupsHistory->createHistoryEntry_intraGroup(
    $request['idObject'],
    $neededArgs['idUser'],
    $request['idUser'],
    $requestedObject['idGroup'],
    false,
    $request['amount']
  );

//As other group
}elseif($request['idGroup'] != null){
  $idLoan = $GroupsLoans->createLoanByGroup(
    $request['idGroup'],
    $request['idObject'],
    $request['idUser'],
    $request['amount']
  );

  $hid = $GroupsHistory->createHistoryEntry_toOtherGroup(
    $request['idObject'],
    $neededArgs['idUser'],
    $request['idUser'],
    $request['idGroup'],
    false,
    $request['amount']
  );

//As particular user
}else{
  $idLoan = $GroupsLoans->createLoanByUser(
    $request['idUser'],
    $request['idObject'],
    null,
    $request['amount']
  );

  $hid = $GroupsHistory->createHistoryEntry_toOtherUser(
    $request['idObject'],
    $neededArgs['idUser'],
    $request['idUser'],
    false,
    $request['amount']
  );
  
}
if ($idLoan == null) ResponseManager::returnErrorResponse('invalidData');
//Delete the request
$deleted = $GroupsRequests->deleteRequest($neededArgs['idRequest']);
if ($deleted === false) ResponseManager::returnErrorResponse('invalidData');

//Return
$json['idLoan'] = $idLoan;
ResponseManager::returnSuccessResponse(1, $json);
?>
