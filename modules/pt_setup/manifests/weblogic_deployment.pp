# Custom Puppet Class to deploy WebLogic using the DPK
class pt_setup::weblogic_deployment (
  $ensure                 = present,
  $deploy_pshome_only     = false,
  $tools_archive_location = undef,
  $tools_install_user     = undef,
  $tools_install_group    = undef,
  $oracle_install_user    = undef,
  $oracle_install_group   = undef,
  $db_type                = undef,
  $pshome_location        = undef,
  $pshome_remove          = true,
  $inventory_location     = undef,
  $oracleclient_location  = undef,
  $oracleclient_remove    = true,
  $jdk_location           = undef,
  $jdk_remove             = true,
  $weblogic_location      = undef,
  $weblogic_remove        = true,
  $tuxedo_location        = undef,
  $tuxedo_remove          = true,
  $ohs_location           = undef,
  $ohs_remove             = true,
  $redeploy               = false,
) {
  
  notice ("Applying pt_setup::weblogic_deployment")

  $jdk_tag          = 'jdk'
  $weblogic_tag     = 'weblogic'

  $jdk_archive_file      = get_matched_file($tools_archive_location, $jdk_tag)
  if $jdk_archive_file == '' {
    fail("Unable to locate archive (tgz) file for JDK in ${tools_archive_location}")
  }
  $weblogic_archive_file = get_matched_file($tools_archive_location, $weblogic_tag)
  if $weblogic_archive_file == '' {
    fail("Unable to locate archive (tgz) file for Weblogic in ${tools_archive_location}")
  }

  $jdk_patches = hiera('jdk_patches', '')
  if ($jdk_patches) and ($jdk_patches != '') {
    notice ("JDK patches exists")
    $jdk_patches_list = values($jdk_patches)
  }
  else {
    notice ("JDK  patches does not exists")
    $jdk_patches_list = undef
  }

  pt_deploy_jdk { $jdk_tag:
    ensure            => $ensure,
    deploy_user       => $tools_install_user,
    deploy_user_group => $tools_install_group,
    archive_file      => $jdk_archive_file,
    deploy_location   => $jdk_location,
    redeploy          => $redeploy,
    remove            => $jdk_remove,
    patch_list        => $jdk_patches_list,
  }

  $weblogic_patches = hiera('weblogic_patches', '')
  if ($weblogic_patches) and ($weblogic_patches != '') {
    notice ("Weblogic patches exists")
    $weblogic_patches_list = values($weblogic_patches)
  }
      
  pt_deploy_weblogic { $weblogic_tag:
    ensure                    => $ensure,
    deploy_user               => $tools_install_user,
    deploy_user_group         => $tools_install_group,
    archive_file              => $weblogic_archive_file,
    deploy_location           => $weblogic_location,
    oracle_inventory_location => $inventory_location,
    oracle_inventory_user     => $oracle_install_user,
    oracle_inventory_group    => $oracle_install_group,
    jdk_location              => $jdk_location,
    redeploy                  => $redeploy,
    remove                    => $weblogic_remove,
    patch_list                => $weblogic_patches_list,
    require                   => Pt_deploy_jdk['jdk'],
  }
  
}