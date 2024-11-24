#out the url of the api
output "api_url" {
    value = var.domain
}

#Out the certification arn to use it on other modules
output "api_cert_arn" {
    value = aws_acm_certificate.domain_cert.arn
}

#Out the Zone id which we get it from data source to use it on other modules
output "zone_id" {
  value = data.aws_route53_zone.domain_zone.zone_id
}