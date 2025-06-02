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

# Создаем виртуальную сеть
resource "yandex_vpc_network" "main_network" {
  name = "main-network"
}

# Создаем подсеть для всех ресурсов
resource "yandex_vpc_subnet" "main_subnet" {
  name       = "main-subnet"
  network_id = yandex_vpc_network.main_network.id
  zone       = "ru-central1-a"
  ipv4_range = "192.168.0.0/24"
}

# Создаем ВМ для CRM
resource "yandex_compute_instance" "crm_vm" {
  name = "crm-vm"
  zone = "ru-central1-a"

  resources {
    memory = "8"
    cores  = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83e5b9f59c4867b95f" # ID образа Ubuntu 22.04
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    nat       = true
  }
}

# Создаем ВМ для интернет-магазина
resource "yandex_compute_instance" "shop_vm" {
  name = "shop-vm"
  zone = "ru-central1-a"

  resources {
    memory = "8"
    cores  = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83e5b9f59c4867b95f" # ID образа Ubuntu 22.04
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    nat       = true
  }
}

# Создаем Managed MySQL
resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name       = "mysql-cluster"
  environment = "PRODUCTION"
  network_id = yandex_vpc_network.main_network.id
  version    = "8.0"

  config_spec {
    resources {
      resource_preset_id = "b1.medium"
      disk_size          = 10
      disk_type_id       = "network-ssd"
    }

    user {
      name     = "admin"
      password = "CHANGE_ME" # Замените на свой пароль
    }
  }

  host {
    zone = "ru-central1-a"
  }
}

# Создаем правила файрвола для доступа к MySQL
resource "yandex_vpc_security_list" "mysql_security" {
  name = "mysql-security"
  network_id = yandex_vpc_network.main_network.id

  ingress {
    protocol    = "tcp"
    port        = 3306
    description = "Allow MySQL access from CRM VM"
    v4_cidr_blocks = [
      yandex_compute_instance.crm_vm.network_interface[0].ip_address
    ]
  }

  ingress {
    protocol    = "tcp"
    port        = 3306
    description = "Allow MySQL access from Shop VM"
    v4_cidr_blocks = [
      yandex_compute_instance.shop_vm.network_interface[0].ip_address
    ]
  }
}

