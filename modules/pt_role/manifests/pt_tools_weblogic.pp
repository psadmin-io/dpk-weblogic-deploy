class pt_role::pt_tools_weblogic inherits pt_role::pt_base {

  notify { "Applying pt_role::pt_tools_weblogic": }

  $ensure   = hiera('ensure')

  contain ::pt_profile::pt_weblogic
  Class['::pt_profile::pt_weblogic'] 

}
