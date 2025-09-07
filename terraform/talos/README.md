# Talos Terraform Configuration

## Proxmox setup for Terraform
Init user info
```
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum user add terraform-prov@pve --password password
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

If there is an issue with permissions run
```
pveum role modify TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
```

### Local vars
export PM_USER="terraform-prov@pve"
export PM_PASS="password"

## Talosctl setup
```
curl -sL https://talos.dev/install | sh
```

## Run Terraform
```
terraform plan
terraform apply
```

## Bootstrap cluster
At the start you only need the ip for one control node, which can be found in the console tab in proxmox

```
talosctl gen config talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443 --output-dir _out --install-image  factory.talos.dev/nocloud-installer/e56585505a2c794a7df2e9b0ab1614d421aaf1f1e3262e5abb47e20002cbb878:v1.10.6
```
to figure out which disk to boot to (prob vda)
```
talosctl get disks --insecure --nodes $CONTROL_PLANE_IP
```
if it is not sda, update controlplane.yml and worker.yaml to replace sda with what it is

apply control plane config
```
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file _out/controlplane.yaml
```
wait for the first one to finish running then
repeat this step for the rest of the control planes

then you will get an error telling you to run bootstrap
```
export TALOSCONFIG="_out/talosconfig"
talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP
```
then
```
talosctl bootstrap
```
and finally
```
talosctl kubeconfig .
```

to add worker nodes
```
talosctl apply-config --insecure --nodes $WORKER_IP --file _out/worker.yaml
```
