<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idLoan'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$GroupsLoans = new GroupsLoans($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsHistory = new GroupsHistory($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$loan = $GroupsLoans->getLoan($neededArgs['idLoan']);
if ($loan == null) ResponseManager::returnErrorResponse('invalidData');
$object = $GroupsObjects->getObject($loan['idObject']);
if ($object == null) ResponseManager::returnErrorResponse('invalidData'); //BUG IN DB (FOREIGN KEY)
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $object['idGroup']);
if ($admin === false) ResponseManager::returnErrorResponse('permission'); // You have to be an admin of the owner group

//Delete the loan
$success = $GroupsLoans->deleteLoan($neededArgs['idLoan']);

//Store the transaction in the history of the object
$intraGroup = ($loan['idGroup'] === $object['idGroup']);
if ($success){
  if ($intraGroup){
    $hid = $GroupsHistory->createHistoryEntry_intraGroup(
      $loan['idObject'],
      $neededArgs['idUser'],
      $loan['idUser'],
      $object['idGroup'],
      true,
      $loan['amount']
    );
  }elseif ($loan['idGroup'] != null) {
    $hid = $GroupsHistory->createHistoryEntry_toOtherGroup(
      $loan['idObject'],
      $neededArgs['idUser'],
      $loan['idUser'],
      $loan['idGroup'],
      true,
      $loan['amount']
    );
  }else{
    $hid = $GroupsHistory->createHistoryEntry_toOtherUser(
      $loan['idObject'],
      $neededArgs['idUser'],
      $loan['idUser'],
      true,
      $loan['amount']
    );
  }
}

//Return
$json['success'] = $success;
ResponseManager::returnSuccessResponse(2, $json);
?>
