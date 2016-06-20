# Verify the Oracle Base folder is present - DPK doesn't like it when the base folder isn't created.
file { hiera('oracle_base') :
	ensure => hiera('ensure'),
}

# Call custom profile to install WebLogic (and JDK)
node default {
  include ::pt_role::pt_tools_weblogic
}

