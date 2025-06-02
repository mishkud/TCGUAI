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

# Основные переменные
variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "network_name" {
  description = "Имя сети"
  type        = string
  default     = "app-network"
}

variable "subnet_name" {
  description = "Имя подсети"
  type        = string
  default     = "app-subnet"
}

variable "subnet_cidr" {
  description = "CIDR блок для подсети"
  type        = string
  default     = "10.2.0.0/16"
}

variable "crm_vm_name" {
  description = "Имя ВМ для CRM"
  type        = string
  default     = "crm-server"
}

variable "shop_vm_name" {
  description = "Имя ВМ для интернет-магазина"
  type        = string
  default     = "shop-server"
}

variable "db_name" {
  description = "Имя базы данных"
  type        = string
  default     = "app-database"
}

variable "db_user" {
  description = "Имя пользователя для базы данных"
  type        = string
  default     = "db-user"
}

variable "db_password" {
  description = "Пароль для базы данных"
  type        = string
  default     = "Pa$$w0rd"
  sensitive   = true
}

# Создание сети
resource "yandex_vpc_network" "app_network" {
  name = var.network_name
}

# Создание подсети
resource "yandex_vpc_subnet" "app_subnet" {
  name           = var.subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.app_network.id
  v4_cidr_blocks = [var.subnet_cidr]
}

# Создание ВМ для CRM
resource "yandex_compute_instance" "crm_vm" {
  name        = var.crm_vm_name
  zone        = var.zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80qm01ah03dkqb14lc" # Ubuntu 20.04
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Создание ВМ для интернет-магазина
resource "yandex_compute_instance" "shop_vm" {
  name        = var.shop_vm_name
  zone        = var.zone
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80qm01ah03dkqb14lc" # Ubuntu 20.04
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Создание кластера MySQL
resource "yandex_mdb_mysql_cluster" "app_mysql" {
  name        = var.db_name
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.app_network.id
  version     = "8.0"

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  database {
    name = "app_db"
  }

  user {
    name     = var.db_user
    password = var.db_password
    permission {
      database_name = "app_db"
      roles         = ["ALL"]
    }
  }

  host {
    zone      = var.zone
    subnet_id = yandex_vpc_subnet.app_subnet.id
  }
}

# Outputs для важных значений
output "crm_vm_external_ip" {
  value = yandex_compute_instance.crm_vm.network_interface.0.nat_ip_address
  description = "Внешний IP-адрес ВМ для CRM"
}

output "shop_vm_external_ip" {
  value = yandex_compute_instance.shop_vm.network_interface.0.nat_ip_address
  description = "Внешний IP-адрес ВМ для интернет-магазина"
}

output "mysql_host" {
  value = yandex_mdb_mysql_cluster.app_mysql.host[0].fqdn
  description = "FQDN хоста MySQL"
}
