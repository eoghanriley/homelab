locals {
  talos_nodes = {
    highmountain-control-01 = {
      vmid = "800"
    }
  }
}

resource "proxmox_vm_qemu" "highmountain" {
  for_each = local.talos_nodes

  agent = 1
  boot = "order=virtio0;ide2;net0"
  cpu {
    cores = 8
  }
  memory = 16384
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
          size = "200G"
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
