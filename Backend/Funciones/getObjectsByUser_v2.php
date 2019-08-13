<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser'
]);

//Logic
$Users = new Users($pdo
$UsersObjects = new UsersObjects($pdo);
$UsersRequests = new UsersRequests($pdo);
$UsersLoans = new UsersLoans($pdo);
$UsersClaims = new UsersClaims($pdo);

$usr = $Users->getUser($neededArgs['idUser']);
if ($usr == null) ResponseManager::returnErrorResponse('invalidData');

$objects = $UsersObjects->getObjects($neededArgs['idUser']);
$requests = $UsersRequests->getRequestsToUser($neededArgs['idUser']);
$loansByMe = $UsersLoans->getLoansByUser($neededArgs['idUser']);
$claimsByMe = $UsersClaims->getClaimsByUser($neededArgs['idUser']);
if ($objects == null) $objects = [];
if ($requests == null) $requests = [];
if ($loansByMe == null) $loansByMe = [];
if ($claimsByMe == null) $claimsByMe = [];


$BYproperty = $objects; // MY OBJECTS + REQUESTS TO THEM
$BYauthority = $objects; // MY OBJECTS - OBJS I HAVE LOAN TO OTHER (claims in each loan)
for ($i=0; $i < count($objects) ; $i++) {
  $BYproperty[$i]['reqN'] = 0;
  $BYproperty[$i]['requests'] = [];

  $BYauthority[$i]['loN'] = 0;
  $BYauthority[$i]['loans'] = [];

  //Add the requests
  foreach ($requests as &$req) {
    if ($BYproperty[$i]['idObject'] === $req['idObject']){
      $BYproperty[$i]['reqN']++;
      $BYproperty[$i]['requests'][] = $req;
    }
  }
  //Substract the loans
  foreach ($loansByMe as &$lo) {
    $lo['clN'] = 0;
    $lo['claims'] = [];
    foreach ($claimsByMe as &$claim) {
      if ($lo['idLoan'] === $claim['idLoan']){
        $lo['clN']++;
        $lo['claims'][] = $claim;
      }
    }
    if ($BYauthority[$i]['idObject'] === $lo['idObject']){
      $BYauthority[$i]['amount'] -= $lo['amount'];
      $BYauthority[$i]['loN']++;
      $BYauthority[$i]['loans'][] = $lo;
    }
  }
}

$loansToMe = $UsersLoans->getLoansToUser($neededArgs['idUser']);
$claimsToMe = $UsersClaims->getClaimsToUser($neededArgs['idUser']);

$BYlent = []; //OBJECTS SOMEONE HAVE LENT TO ME + CLAIMS THAT CAN HAVE BEEN DONE
foreach ($loansToMe as &$loan) {
  $obj = $UsersObjects->getObject($loan['idObject']);
  $obj['amount'] = $loan['amount'];
  $obj['idLoan'] = $loan['idLoan'];
  $obj['clN'] = 0;
  $obj['claims'] = [];
  foreach ($claimsToMe as &$claim) {
    if ($loan['idLoan'] === $claim['idLoan']){
      $obj['clN']++;
      $obj['claims'][] = $claim;
    }
  }
  $BYlent[] = $obj;
}

$json['BYproperty'] = $BYproperty;
$json['BYauthority'] = $BYauthority;
$json['BYlent'] = $BYlent;
//Return
ResponseManager::returnSuccessResponse(4, $json);
?>
