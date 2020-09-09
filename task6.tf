provider "aws" {
 region = "ap-south-1"
 }

resource "aws_db_instance" "MySQL_Database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.30"
  identifier           = "mysql"
  instance_class       = "db.t2.micro"
  name                 = "MySQL_Database"
  username             = "rakesh"
  password             = "rakesh123"
  parameter_group_name = "default.mysql5.7"
 // deletion_protection =  true
  auto_minor_version_upgrade = true
  publicly_accessible = true
  port = "3306"
  vpc_security_group_ids= ["sg-c389f6a1",]
  final_snapshot_identifier = false
  skip_final_snapshot = true
 
}
provider "kubernetes" {
    config_context_cluster = "minikube"
}

resource "kubernetes_service" "service" {
  metadata {
    name = "task6-wp"
  }
  spec {
    selector = {
      app = kubernetes_deployment.Wordpress.metadata.0.labels.app
    }
    port {
      node_port = 30000
      port        = 8080
      target_port = 80
    }
    type = "NodePort"
  }
}

resource "kubernetes_deployment" "Wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      app = "webapp"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "webapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress-container"
            port {
               container_port = 80
                     }
                }
           }
      }
  } 
}