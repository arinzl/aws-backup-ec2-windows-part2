locals {

  tags_generic = {
    environment = var.environment
    costcentre  = "TBC"
    ManagedBy   = var.ManagedByLocation
  }

  tag_backup = {
    Application = "Tutorial backup Primary"
  }

  tags_ec2 = {
    appname    = var.ec2_app_name
    backuptier = "2VSS"
  }

  tags_ssm_ssm = {
    Name = "myvpc-vpce-interface-ssm-ssm"
  }

  tags_ssm_ssmmessages = {
    Name = "myvpc-vpce-interface-ssm-ssmmessages"
  }

  tags_ssm_ec2messages = {
    Name = "myvpc-vpce-interface-ssm-ec2messages"
  }

  user_data_prod = <<-EOT
<powershell>
Set-TimeZone -Name "New Zealand Standard Time"
New-Item -Path "c:\temp" -Name "logfiles" -ItemType "directory"

## VSS Backup component install
c:
cd \temp
$Instance_ID = (Invoke-WebRequest -Uri http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).Content
$Instance_ID > c:\temp\test.txt
Send-SSMCommand -DocumentName AWS-ConfigureAWSPackage -InstanceId $Instance_ID -Parameter @{'action'='Install';'name'='AwsVssComponents'} -Comment $Instance_ID > c:\temp\awsvsscomponents.txt
Start-Sleep -Seconds 30

</powershell>
  EOT
}
