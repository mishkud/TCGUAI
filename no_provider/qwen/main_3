terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "<зона_доступности_по_умолчанию>"
}

# Переменные, которые можно изменить при необходимости
variable "vm_zone" {
  description = "Зона размещения ВМ"
  default     = "ru-central1-a"
}

variable "db_zone" {
  description = "Зона размещения БД"
  default     = "ru-central1-a"
}

variable "subnet_id" {
  description = "Идентификатор подсети, в которую будут развёрнуты ресурсы"
  type        = string
}

variable "public_ssh_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
}

# Сеть и подсеть предполагаются существующими — заданы через переменную выше

# Виртуальная машина для CRM
resource "yandex_compute_instance" "crm_vm" {
  name        = "crm-vm"
  zone        = var.vm_zone
  subnet_id   = var.subnet_id
  description = "CRM server"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd83j9q4v7i4o9s4th6k" # Ubuntu 22.04 LTS
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
  }
}

# Виртуальная машина для интернет-магазина
resource "yandex_compute_instance" "shop_vm" {
  name        = "shop-vm"
  zone        = var.vm_zone
  subnet_id   = var.subnet_id
  description = "E-commerce platform server"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd83j9q4v7i4o9s4th6k" # Ubuntu 22.04 LTS
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
  }
}

# Managed MySQL база данных
resource "yandex_mdb_mysql_cluster" "default" {
  name        = "mysql-db"
  environment = "PRESTABLE"
  network_id  = "your-network-id" # Замените на ID вашей сети
  version     = "8.0"

  cluster_config {
    mysql_config {
      max_connections = 1024
    }
  }

  databases {
    name = "appdb"
    owner = "user1"
  }

  users {
    name     = "user1"
    password = "securepassword123"
    permission {
      database_name = "appdb"
      roles         = ["ALL"]
    }
  }

  host {
    zone      = var.db_zone
    subnet_id = var.subnet_id
  }
}
