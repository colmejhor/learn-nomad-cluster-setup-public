# volume registration
id = "fs-014870fcedfd1c584"
name = "fs-014870fcedfd1c584"
type = "csi"
plugin_id = "aws-efs0"

capability {
  # access_mode     = "single-node-writer"
  access_mode     = "multi-node-multi-writer"
  attachment_mode = "file-system"
}

parameters {
  provisioningMode = "efs-ap"
  fileSystemId = "fs-014870fcedfd1c584"
  directoryPerms = "700"
  gidRangeStart = "1000"
  gidRangeEnd = "2000"
}
