module "cdn" {
    source = "./modules/cdn"
}

module "route53" {
    source = "./modules/route53"
}

module "s3" {
    source = "./modules/s3"
}

