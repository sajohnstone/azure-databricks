locals {
  # Decode the JSON response from the ifconfig.co API to get the public IP address of the host machine
  ifconfig_co_json = jsondecode(data.http.my_public_ip.response_body)

  // Re-organize subnets to a map
  subnets = { for item in flatten([for key, value in var.vnets : [
    for snet in value.subnets : {
      full_key         = "${key}-${snet.name}"
      snet_key         = snet.name
      address_prefixes = snet.address_prefix
      vnet_key         = key
    }]
  ]) : item.full_key => item }
}
