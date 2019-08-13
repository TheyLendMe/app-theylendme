<?php
//Logic
$Groups = new Groups($pdo);

$grps = $Groups->getPublicGroups();
if ($grps == null) $grps = [];
$json['publicGroups'] = [];

foreach ($grps as &$grp) {
  unset($grp['private']);
  unset($grp['autoloan']);
  unset($grp['email']);
  unset($grp['tfno']);
  unset($grp['info']);
  $json['publicGroups'][] = $grp;
}

//Return
ResponseManager::returnSuccessResponse(4, $json);
?>
