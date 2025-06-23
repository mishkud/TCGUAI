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

# Переменные, которые пользователь должен задать
variable "yc_token" {
  description = "OAuth токен для доступа к Yandex Cloud"
  type        = string
}

variable "yc_cloud_id" {
  description = "Идентификатор облака в Yandex Cloud"
  type        = string
}

variable "yc_folder_id" {
  description = "Идентификатор папки в Yandex Cloud"
  type        = string
}

variable "yc_zone" {
  description = "Зона доступности в Yandex Cloud"
  type        = string
  default     = "ru-central1-a"
}

# Создание виртуальной машины для CRM
resource "yandex_compute_instance" "crm_vm" {
  name        = "crm-vm"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87tirk5i8vitv8uuo1" # Ubuntu 20.04 LTS
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Создание виртуальной машины для интернет-магазина
resource "yandex_compute_instance" "shop_vm" {
  name        = "shop-vm"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87tirk5i8vitv8uuo1" # Ubuntu 20.04 LTS
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Создание управляемой базы данных MySQL
resource "yandex_mdb_mysql_cluster" "mysql_db" {
  name        = "mysql-db"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.default.id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  database {
    name = "crm_db"
  }

  user {
    name     = "admin"
    password = "yourpassword"
    permission {
      database_name = "crm_db"
      roles         = ["ALL"]
    }
  }

  host {
    zone      = var.yc_zone
    subnet_id = yandex_vpc_subnet.default.id
  }
}

# Создание сети и подсети
resource "yandex_vpc_network" "default" {
  name = "default-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "default-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}

