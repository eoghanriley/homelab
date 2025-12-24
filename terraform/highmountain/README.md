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
talosctl gen config talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443 --output-dir _out --install-image https://factory.talos.dev/image/e5d4ce8e5c33d77e02e0642b7fb2343657ebbd648a3bf6da6a3b4f347417ec72/v1.12.0/nocloud-amd64.iso
```
to figure out which disk to boot to (prob vda)
```
talosctl get disks --insecure --nodes $CONTROL_PLANE_IP
```
if it is not sda, update controlplane.yml and worker.yaml to replace sda with what it is

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

If you want to run pods on control plane nodes
```
kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
```