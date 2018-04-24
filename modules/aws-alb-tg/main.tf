module "aws-alb-tg" {
  source          = "git::https://github.com/unicanova/terraform-aws-alb-tg.git?ref=master"
  certificate_arn = "arn:aws:acm:us-east-1:329942816198:certificate/338d2752-79c7-4cb6-a022-eb2f0d558704"
  region          = "us-east-1"
  alb_name        = "alb-dev"
  instance_tags   = {
    "instance_name" = "unicanova"
    "instance_env"  = "dev"
  }
  security_groups = ["sg-1953db68"]
}
