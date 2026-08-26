variable "virtual_environment_endpoint" {
  description = "proxmox endpoint"
  type        = string
  sensitive   = true
}

variable "virtual_environment_username" {
  description = "Nazwa użytkownika do Proxmox"
  type        = string
}

variable "virtual_environment_password" {
  description = "Hasło do Proxmox"
  type        = string
  sensitive   = true
}

variable "virtual_environment_node_name" {
  description = "Nazwa clustra"
  type        = string
}

variable "datastore_id_vms" {
  description = "datastore_id_vms"
  type        = string
}

variable "datastore_id_iso" {
  description = "Datastore dla obrazów ISO/import"
  type        = string
}

variable "datastore_id_files" {
  description = "Datastore dla obrazów ISO/import"
  type        = string
}

variable "datastore_id_vms_hdd" {
  description = "Datastore dla obrazów ISO/import"
  type        = string
}

# ============================================================
# Ansible
# ============================================================

variable "ansible_playbooks" {
  description = "Mapa VM -> playbook uruchamiany po utworzeniu VM. Dostępne klucze: ubuntu22, ubuntu24, ubuntu26, cloudportal. Brak klucza = nie uruchamiaj Ansible."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for vm_name in keys(var.ansible_playbooks) :
      contains(["ubuntu22", "ubuntu24", "ubuntu26", "cloudportal"], vm_name)
    ])
    error_message = "ansible_playbooks może zawierać tylko: ubuntu22, ubuntu24, ubuntu26, cloudportal."
  }
}

variable "ansible_user" {
  description = "Użytkownik SSH używany przez Ansible"
  type        = string
  default     = "chris"
}

variable "ansible_private_key_file" {
  description = "Opcjonalna ścieżka do prywatnego klucza SSH. Gdy null, Ansible użyje standardowej konfiguracji SSH."
  type        = string
  default     = null
  nullable    = true
}

variable "ansible_command" {
  description = "Polecenie uruchamiające Ansible. Linux/WSL: ansible-playbook. Windows z WSL: wsl ansible-playbook."
  type        = string
  default     = "ansible-playbook"
}

variable "ansible_extra_args" {
  description = "Dodatkowe argumenty przekazywane do ansible-playbook"
  type        = string
  default     = ""
}
