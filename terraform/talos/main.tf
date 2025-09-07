locals {
  talos_nodes = {
    talos-control-01 = {
      vmid = "801"
    }
    talos-control-02 = {
      vmid = "802"
    }
    talos-control-03 = {
      vmid = "803"
    }
  }
}

resource "proxmox_vm_qemu" "talos" {
  for_each = local.talos_nodes

  agent = 1
  boot = "order=virtio0;ide2;net0"
  cpu {
    cores = 2
  }
  memory = 4096
  scsihw = "virtio-scsi-single"
  name = each.key
  target_node = "thunderbluff"
  vmid = each.value.vmid

  disks {
    ide {
      ide2 {
        cdrom {
          iso = "local:iso/nocloud-amd64.iso"
        }
      }
    }

    virtio {
      virtio0 {
        disk {
          size = "50G"
          storage = "sda-lvm"
        }
      }
    }
  }

  network {
    bridge = "vmbr0"
    id = "0"
    model = "virtio"
  }
}
