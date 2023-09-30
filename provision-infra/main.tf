#root/main.tf

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  public_sn_count  = 1
  private_sn_count = 4
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(3, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  security_groups  = local.security_groups
  db_subnet_group  = true
}

# module "database" {
#   source                 = "./database"
#   db_engine_version      = "8.0.33"
#   db_instance_class      = "db.t2.micro"
#   dbname                 = var.dbname
#   dbuser                 = var.dbuser
#   dbpassword             = var.dbpassword
#   db_identifier          = "mtc-db"
#   skip_db_snapshot       = true
#   db_subnet_group_name   = module.networking.db_subnet_group_name[0]
#   vpc_security_group_ids = [module.networking.db_security_group]
# }

# module "loadbalancing" {
#   source            = "./LB"
#   public_sg         = module.networking.public_sg
#   private_subnets_a = module.networking.private_subnets_a[1]
#   private_subnets_c = module.networking.private_subnets_c[1]
#   tg_port                 = 80
#   tg_protocol             = "HTTP"
#   vpc_id                  = module.networking.vpc_id
#   elb_healthy_threshold   = 2
#   elb_unhealthy_threshold = 2
#   elb_timeout             = 3
#   elb_interval            = 30
#   listener_port           = 80
#   listener_protocol       = "HTTP"
# }

module "compute" {
  source         = "./compute"
  public_sg      = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  instance_count = 1
  instance_type  = "t2.micro"
  vol_size       = "20"
  key_name = "vti"
  public_key_path = "/home/heyhuy/.ssh/vti.pub"
}