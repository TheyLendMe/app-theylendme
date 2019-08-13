<?php
//FIXME ?¿?¿¿? : Requereir idOtherUser y permitir observar otro usuario distinto al propio
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);

//Logic
$Users = new Users($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$JoinRequests = new JoinRequests($pdo);
$Groups = new Groups($pdo);
$authManager = new AuthManager($Users);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
// }

$members = $GroupsMembers->getMembersByUser($neededArgs['idUser']);
$requests = $JoinRequests->getRequestsByUser($neededArgs['idUser']);

$json['admin'] = [];
$json['member'] = [];
$json['request'] = [];

for ($i=0; $i < count($members) ; $i++) {
  $key = ($members[$i]['admin'] == true ? 'admin' : 'member');

  $grp = $Groups->getGroup($members[$i]['idGroup']);
  // unset($grp['private']);
  // unset($grp['autoloan']);
  // unset($grp['email']);
  // unset($grp['tfno']);
  // unset($grp['info']);

  $json[$key][] = $grp;
}

for ($i=0; $i < count($requests); $i++) {
  $grp = $Groups->getGroup($requests[$i]['idGroup']);

  // unset($grp['private']);
  // unset($grp['autoloan']);
  // unset($grp['email']);
  // unset($grp['tfno']);
  // unset($grp['info']);

  $json['request'][] = $grp;
}

ResponseManager::returnSuccessResponse(4, $json);
?>
