# volume registration
id = "jenkins_efs"
name = "jenkins_efs"
type = "csi"
plugin_id = "aws-efs"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}

parameters {
  provisioningMode = "efs-ap"
  fileSystemId = "fs-014870fcedfd1c584"
  directoryPerms = "700"
  gidRangeStart = "1000"
  gidRangeEnd = "2000"
}
