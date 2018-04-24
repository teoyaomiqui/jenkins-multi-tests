module "aws-alb-tg" {
  source = "github.com/unicanova/terraform-aws-alb-tg"
  certificate_arn = "arn:aws:acm:us-east-1:329942816198:certificate/338d2752-79c7-4cb6-a022-eb2f0d558704"
}
