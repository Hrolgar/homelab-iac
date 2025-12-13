variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "description" {
  description = "VM description"
  type        = string
  default     = ""
}

variable "node" {
  description = "Proxmox node to deploy on"
  type        = string
}

variable "template_id" {
  description = "Template VM ID to clone"
  type        = number
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "CPU type (host, x86-64-v2-AES, etc.)"
  type        = string
  default     = "host"
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size (e.g., 20, 50, 100 in GB)"
  type        = number
  default     = 20
}

variable "storage" {
  description = "Storage pool for disk"
  type        = string
  default     = "local-lvm"
}

variable "ip" {
  description = "Static IP address"
  type        = string
}

variable "gateway" {
  description = "Gateway address"
  type        = string
  default     = "10.69.1.1"
}

variable "nameserver" {
  description = "DNS server"
  type        = string
  default     = "10.69.1.4"
}

variable "vlan" {
  description = "VLAN tag (null for untagged)"
  type        = number
  default     = null
}

variable "onboot" {
  description = "Start VM on boot"
  type        = bool
  default     = true
}

variable "started" {
  description = "Start VM after creation"
  type        = bool
  default     = true
}

variable "ci_user" {
  description = "Cloud-init username"
  type        = string
  default     = "hrolgar"
}

variable "ci_password" {
  description = "Cloud-init password"
  type        = string
  sensitive   = true
}

variable "ci_ssh_keys" {
  description = "SSH public keys for cloud-init"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = []
}

variable "pool" {
  description = "Pool to assign VM to"
  type        = string
  default     = null
}