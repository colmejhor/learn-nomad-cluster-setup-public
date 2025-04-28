# volume registration
type        = "csi"
id          = "mysql"
name        = "mysql"
external_id = "vol-0dc69a8c685fa5a40"
plugin_id   = "aws-ebs0"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}