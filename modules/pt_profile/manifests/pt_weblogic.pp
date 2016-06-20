# Custom Profile to prepare for WebLogic installation
class pt_profile::pt_weblogic {
  notify { "Applying pt_profile::pt_weblogic": }

  ## Hiera lookups
  $ensure                    = hiera('ensure')
  $env_type                  = hiera('env_type')
  
  $tools_archive_location      = hiera('archive_location')

  $jdk_hiera             = hiera('jdk')
  $jdk_location          = $jdk_hiera['location']
  $jdk_remove_value      = $jdk_hiera['remove']
  if $jdk_remove_value == false {
    $jdk_remove = false
  }
  else {
    $jdk_remove = true
  }
  notice ("JDK remove is ${jdk_remove}")

  $weblogic_hiera        = hiera('weblogic')
  $weblogic_location     = $weblogic_hiera['location']
  $weblogic_remove_value = $weblogic_hiera['remove']
  if $weblogic_remove_value == false {
    $weblogic_remove = false
  }
  else {
    $weblogic_remove = true
  }
  notice ("Weblogic remove is ${weblogic_remove}")

  $redeploy = hiera('redeploy', false)
  class { '::pt_setup::weblogic_deployment':
    ensure                 => $ensure,
    tools_archive_location => $tools_archive_location,
    inventory_location     => $inventory_location,
    jdk_location           => $jdk_location,
    jdk_remove             => $jdk_remove,
    weblogic_location      => $weblogic_location,
    weblogic_remove        => $weblogic_remove,
    redeploy               => $redeploy,
  }
  contain ::pt_setup::weblogic_deployment
}
